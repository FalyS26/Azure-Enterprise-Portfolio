variable "location" {
  description = "Primary Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group for the image factory"
  type        = string
}

variable "gallery_name" {
  description = "Azure Compute Gallery name"
  type        = string
}

variable "image_definition_name" {
  description = "Hardened image definition name"
  type        = string
}