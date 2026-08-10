variable "location" {
  description = "Azure region for all project resources"
  type        = string
}

variable "environment" {
  description = "Environment name such as Production or Development"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group name for shared hub networking resources"
  type        = string
}

variable "app_resource_group_name" {
  description = "Resource group name for the application spoke"
  type        = string
}

variable "internal_resource_group_name" {
  description = "Resource group name for the internal spoke"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "app_vnet_name" {
  description = "Name of the application spoke virtual network"
  type        = string
}

variable "internal_vnet_name" {
  description = "Name of the internal spoke virtual network"
  type        = string
}

variable "hub_address_space" {
  description = "Address space for the hub virtual network"
  type        = list(string)
}

variable "app_address_space" {
  description = "Address space for the application spoke virtual network"
  type        = list(string)
}

variable "internal_address_space" {
  description = "Address space for the internal spoke virtual network"
  type        = list(string)
}