terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }
}

provider "azurerm" {
  features {}

  client_id       = "ca907e21-0e0d-4865-b86b-76b747e9fc86"
  tenant_id       = "665b6c62-7310-4d39-9abb-32a0cbc3b90f"
  client_secret   = "1nc8Q~zCNLGTEfmklHur3FjMkeCszQI-_hQurbvV"
  subscription_id = "727569fb-5294-4ca5-9005-466abf5d33f1"

}
variable "resources_group_names" {
  type    = map
  default = {
    devops  = "devops-g1"
    testt = "test-g1"
    production = "production-g1"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = var.resources_group_names[terraform.workspace]
  location = "central india"
}