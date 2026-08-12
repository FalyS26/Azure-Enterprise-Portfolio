variable "location" {
  description = "Primary Azure region"
  type        = string
}

variable "environment_prod" {
  description = "Production environment label"
  type        = string
}

variable "environment_dev" {
  description = "Development environment label"
  type        = string
}

variable "prod_resource_group_name" {
  description = "Production resource group name"
  type        = string
}

variable "dev_resource_group_name" {
  description = "Development resource group name"
  type        = string
}
variable "developer_principal_id" {
  description = "Microsoft Entra object ID for the developer user or group"
  type        = string
}