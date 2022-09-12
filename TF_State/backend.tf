terraform {
  backend "azurerm" {
    resource_group_name   = "section05"
    storage_account_name  = "tffile05"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
  }
}