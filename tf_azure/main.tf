# terraform {
#   required_providers {
#     azuread = {
#       source = "hashicorp/azuread"
#       version = "2.28.1"
#     }
#   }
# }
 terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.18.0"
    }
  }
}

# provider "azuread" {
# }

# resource "azuread_user" "user" {
#   user_principal_name = "awariambika123@gmail.com"
#   display_name        = "Ambika Aawari"
#   mail_nickname       = "Ambika"
#   password            = "SecretP@sswd99!"
# }

provider "azurerm" {
  features {}
}

resource "azuread_user" "example" {
  user_principal_name = "mtest@ntweekly.local"
  display_name        = "My Test"
  mail_nickname       = "mtest"
  password            = "set password"
}
