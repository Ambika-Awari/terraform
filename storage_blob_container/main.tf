resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.rg1.name
  location                 = var.location
  account_tier             = "Standard" #Premium
  account_replication_type = "LRS" #ZRS GRS
  allow_nested_items_to_be_public = true # allow_blob_access = true
}

resource "azurerm_storage_container" "container" {
  name                  = var.storage_container_name
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "container" # "blob" "private"
}

resource "azurerm_storage_blob" "blob" {
  name                   = "sample-file.sh"
  storage_account_name   = azurerm_storage_account.storage.name
  storage_container_name = azurerm_storage_container.container.name
  type                   = "Block" #page 
  source                 = "commands.sh"
}