provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "web" {
  name     = var.resource_group
  location = var.location
  tags     = var.tags
}

# Provision Virtula Network
resource "azurerm_virtual_network" "web" {
  name                = "${var.prefix}VirtualNetwork"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name

  tags = var.tags
}

# Provision Subnet
resource "azurerm_subnet" "web" {
  name                 = "${var.prefix}Subnet"
  resource_group_name  = azurerm_resource_group.web.name
  virtual_network_name = azurerm_virtual_network.web.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Provision Public IP
resource "azurerm_public_ip" "web" {
  name                = "${var.prefix}publicIPForLB"
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name
  allocation_method   = "Static"

  tags = var.tags
}

# Provision Load Balanacer
resource "azurerm_lb" "web" {
  name                = "${var.prefix}loadBalancer"
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name

  frontend_ip_configuration {
    name                 = "publicIPAddress"
    public_ip_address_id = azurerm_public_ip.web.id
  }

  tags = var.tags
}

resource "azurerm_lb_backend_address_pool" "web" {
  resource_group_name = azurerm_resource_group.web.name
  loadbalancer_id     = azurerm_lb.web.id
  name                = "${var.prefix}BackEndAddressPool"

}

# Provision Network Security Group
resource "azurerm_network_security_group" "web" {
  name                = "${var.prefix}NetworkSecurityGroup"
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Internet"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }


  tags = var.tags
}

# Provision Network Interface Card 
resource "azurerm_network_interface" "web" {
  count               = var.number_instance
  name                = "${var.prefix}NIC_${count.index}"
  location            = azurerm_resource_group.web.location
  resource_group_name = azurerm_resource_group.web.name

  ip_configuration {
    name                          = "webConfiguration"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "dynamic"
  }
  tags = var.tags
}

# Associate  the security group to the network interface card
resource "azurerm_network_interface_security_group_association" "web" {
  count                     = var.number_instance
  network_interface_id      = azurerm_network_interface.web[count.index].id
  network_security_group_id = azurerm_network_security_group.web.id

}

# Provision Mangaed Disk
resource "azurerm_managed_disk" "web" {
  count                = var.number_instance
  name                 = "${var.prefix}DataDiskExisting_${count.index}"
  location             = azurerm_resource_group.web.location
  resource_group_name  = azurerm_resource_group.web.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1023"

  tags = var.tags
}

# Provision Availability Set
resource "azurerm_availability_set" "avset" {
  name                         = "${var.prefix}AvailabilitySet"
  location                     = azurerm_resource_group.web.location
  resource_group_name          = azurerm_resource_group.web.name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true

  tags = var.tags
}

# Packer Image Resource Group
data "azurerm_resource_group" "image" {
  name = "webResourceGroup"
}

# Packer Image
data "azurerm_image" "image" {
  name                = "webDeployWebServerPackerImage"
  resource_group_name = data.azurerm_resource_group.image.name
}

# Provision Virtual Machine
resource "azurerm_virtual_machine" "web" {
  count                 = var.number_instance
  name                  = "${var.prefix}VirtualMachine_${count.index}"
  location              = azurerm_resource_group.web.location
  availability_set_id   = azurerm_availability_set.avset.id
  resource_group_name   = azurerm_resource_group.web.name
  network_interface_ids = [element(azurerm_network_interface.web.*.id, count.index)]
  vm_size               = "Standard_DS1_v2"

  # Delete disk when deleting VM
  delete_os_disk_on_termination = true

  # Delete data disk when deleting VM
  delete_data_disks_on_termination = true


  storage_image_reference {
    id = data.azurerm_image.image.id
  }

  storage_os_disk {
    name              = "${var.prefix}OSDisk_${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Provision Optional Data Disks
  storage_data_disk {
    name              = "${var.prefix}DataDiskNew_${count.index}"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = element(azurerm_managed_disk.web.*.name, count.index)
    managed_disk_id = element(azurerm_managed_disk.web.*.id, count.index)
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = element(azurerm_managed_disk.web.*.disk_size_gb, count.index)
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = var.admin
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = var.tags
}
