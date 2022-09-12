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

  client_id       = "969d33f2-743f-45d4-9866-8e995f507836"
  tenant_id       = "1ca85363-714b-432b-b048-5c7a9f896d62"
  client_secret   = "l~M8Q~pyPfCfwXNAHfZN1rkXFrHkxRyQyC9TpbWI"
  subscription_id = "a52b7487-b59c-45f4-b7ce-2a69748e9fc9"

}