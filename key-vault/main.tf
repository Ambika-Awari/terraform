terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    }

  client_id       = "ca907e21-0e0d-4865-b86b-76b747e9fc86"
  tenant_id       = "665b6c62-7310-4d39-9abb-32a0cbc3b90f"
  client_secret   = "1nc8Q~zCNLGTEfmklHur3FjMkeCszQI-_hQurbvV"
  subscription_id = "727569fb-5294-4ca5-9005-466abf5d33f1"

}


data "azurerm_client_config" "current" {}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_key_vault" "example" {
  name                        = "examplekeyvault"
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
      "list",
      "set",
      "delete",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}

resource "azurerm_key_vault_access_policy" "policy" {
  key_vault_id = azurerm_key_vault.example.id
  tenant_id = data.azurerm_client_config.current.tenant_id
  object_id = "625bd1ca-3e34-4697-9c65-91080f3ab368" # SPN ID

  key_permissions = [
    "get",
  ]

  secret_permissions = [
    "get",
  ]
}