data "azurerm_subscription" "subscription" {
}

resource "azurerm_resource_group_policy_assignment" "pass" {

  name                 = "deny-not-allowed-locations"
  resource_group_id    = "/subscriptions/a52b7487-b59c-45f4-b7ce-2a69748e9fc9/resourceGroups/my_group"
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
  enforce = true
  parameters = <<PARAMETERS
{
  "listOfAllowedLocations": {
    "value": [ "Central India" ]
  }
}
PARAMETERS
}