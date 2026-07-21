variable "location" {
  description = "Azure Region"
  type        = string
}

variable "environment" {
  description = "Deployment Environment"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group Name"
  type        = string
}

variable "vnet_name" {
  description = "Virtual Network Name"
  type        = string
}

variable "address_space" {
  description = "VNet Address Space"
  type        = list(string)
}
variable "appgateway_subnet_prefix" {
  description = "Address range for the Application Gateway subnet"
  type        = string
}

variable "web_subnet_prefix" {
  description = "Address range for the web tier subnet"
  type        = string
}

variable "application_subnet_prefix" {
  description = "Address range for the application tier subnet"
  type        = string
}

variable "bastion_subnet_prefix" {
  description = "Address range for the Azure Bastion subnet"
  type        = string
}
variable "admin_username" {
  description = "Administrator username for the Windows virtual machines"
  type        = string
  default     = "azureadmin"
}

variable "admin_password" {
  description = "Administrator password for the Windows virtual machines"
  type        = string
  sensitive   = true
}

variable "web_vm_size" {
  description = "Azure VM size for the web servers"
  type        = string
  default     = "Standard_D2als_v7"
}