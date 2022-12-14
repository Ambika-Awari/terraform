resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_resource_group_template_deployment" "arm" {
  name                = "arm-deploy"
  resource_group_name = azurerm_resource_group.rg.name
  deployment_mode     = "Complete" # "Incremental"
  template_content = file("arm_template.json") 
  #template_body       = file("arm_template.json")

parameters_content = {
    storageAccountName = "mystorage01"
    storageAccountType = "Standard_LRS"
  }
    
}

# azurerm_resource_group_template_deployment is replacing azurerm_template_deployment
# src: https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment
#
# resource "azurerm_resource_group_template_deployment" "arm" {
# }