variable "prefix" {
  type        = string
  description = "The prefix which should be used for all resources in this solution"
  default     = "linux-azure-webserver"
}


variable "resource_group" {
  type        = string
  description = "The name of the resource group in which the resources are created"
  default     = "packer-rg"
}

variable "location" {
  type        = string
  description = "The location where resources are created"
  default     = "germanywestcentral"
}


variable "number_instance" {
  description = "The number of instance(s) that the vm scale sets would create"
  type        = number
  default     = 2
}

variable "tags" {
  description = "Tags applied to resources for this solution"
  type        = map(string)

  default = {
    Name = "linux-web-server"
  }
}
variable "application_port" {
  type        = string
  description = "The port that you want to expose to the external load balancer"
  default     = 80
}

variable "admin" {
  type        = string
  description = "Default username for admin"

}

variable "admin_password" {
  type        = string
  description = "Default password for admin"

}


