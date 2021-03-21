variable "prefix" {
  description = "The prefix which should be used for all resources in this solution"
  default     = "linux-azure-webserver"
}

variable "location" {
  description = "The Azure Region in which all resources in this solution should be created."
  default     = "germanywestcentral"
}


variable "resource_group" {
  description = "Name of the resource group, including the -rg"
  default     = "linux-web-rg"
  type        = string
}

variable "tags" {
  description = "A map of the tags to use for the resources that are deployed"
  type        = map(string)
  default = {
    Name = "linux-web-server"
  }
}


variable "username" {
  description = "Enter username to associate with the machine"
  type        = string
}



variable "password" {
  description = "Enter password to use to access the machine"
  type        = string
  sensitive   = true

}




variable "packer_resource_group" {
  description = "Resource group of the Packer image"
  default     = "packer-rg"
  type        = string
}

variable "packer_image_name" {
  description = "Image name of the Packer image"
  default     = "linux-packer-image"
  type        = string
}

variable "num_of_vms" {
  description = "Number of VM resources to be  created behnd the load balancer"
  default     = 2
  type        = number
}
