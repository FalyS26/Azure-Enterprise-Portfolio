packer {
  required_plugins {
    azure = {
      source  = "github.com/hashicorp/azure"
      version = ">= 2.0.0"
    }
  }
}

variable "subscription_id" {
  type = string
}

variable "image_version" {
  type = string
}

source "azure-arm" "ubuntu_hardened" {
  subscription_id = var.subscription_id

  use_azure_cli_auth = true

  os_type         = "Linux"
  image_publisher = "Canonical"
  image_offer     = "0001-com-ubuntu-server-jammy"
  image_sku       = "22_04-lts-gen2"

 build_resource_group_name = "rg-imagefactory-prod-eastus-001"
  vm_size = "Standard_D2as_v7"

  shared_image_gallery_destination {
    subscription   = var.subscription_id
    resource_group = "rg-imagefactory-prod-eastus-001"
    gallery_name   = "acgenterpriseimages001"
    image_name     = "ubuntu-hardened-base"
    image_version = var.image_version
  }
}

build {
  sources = ["source.azure-arm.ubuntu_hardened"]

  provisioner "shell" {
    script = "hardening.sh"
  }
}