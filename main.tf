terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }

backend "azurerm" {
    storage_account_name = "sttfstateazdoprac"                              # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstatecontainer"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "prod.terraform.tfstate"                # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
  }

}



provider "azurerm" {
  # Configuration options
  subscription_id = "01202567-6e50-4f04-b07a-77bb79f043f9"
  features {
    
  }
}

resource "azurerm_resource_group" "myfirstrg" {
  location = var.location
  name = "rg-${var.application_name}-${var.environment_name}"
  
}

# locals {
#   storage_regions_array= split(",", var.storage_regions)
# }
# resource "azurerm_storage_account" "example" {
#     count = length(local.storage_regions_array)
#   name                     = "st${var.application_name}${var.environment_name}${count.index}"
#   resource_group_name      = azurerm_resource_group.myfirstrg.name
#   location                 = trimspace(local.storage_regions_array[count.index])
#   account_tier             = "Standard"
#   account_replication_type = "GRS"
# }
# resource "azurerm_log_analytics_workspace" "example" {
#   name                = "law${var.application_name}${var.environment_name}"
#   location            = azurerm_resource_group.myfirstrg.location
#   resource_group_name = azurerm_resource_group.myfirstrg.name
#   sku                 = "PerGB2018"
#   retention_in_days   = 30
# }