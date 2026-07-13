variable "location" {
  description = "Azure deployment region"
  type        = string
}
variable "environment" {
  description = "Deployment environment"
  type        = string
}
variable "owner" {
  description = "Resource owner"
  type        = string
}
variable "project_name" {
  description = "Name of the Azure portfolio project"
  type        = string
}
variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
}
variable "vnet_name" {
  description = "Virtual Network name"
  type        = string
}
variable "windows_vm_name" {
  description = "Name of the Windows management VM"
  type        = string
}

variable "linux_vm_name" {
  description = "Name of the Linux application VM"
  type        = string
}

variable "windows_vm_size" {
  description = "Azure size for the Windows VM"
  type        = string
}

variable "linux_vm_size" {
  description = "Azure size for the Linux VM"
  type        = string
}

variable "admin_username" {
  description = "Administrator username for the virtual machines"
  type        = string
}
variable "admin_password" {
  description = "Administrator password for the virtual machines"
  type        = string
  sensitive   = true
}