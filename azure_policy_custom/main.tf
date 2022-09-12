resource "azurerm_policy_definition" "policy" {
  name         = "my-policy-definition"
  policy_type  = "Custom" #build in
  mode         = "All"
  display_name = "Custom terraform policy"

  policy_rule = <<POLICY_RULE
    {
    "if": {
      "not": {
        "field": "location",
        "in": "[parameters('allowedLocations')]"
      }
    },
    "then": {
      "effect": "audit"
    }
  }
POLICY_RULE

  parameters = <<PARAMETERS
    {
    "allowedLocations": {
      "type": "Array",
      "metadata": {
        "description": "The list of allowed locations for resources.",
        "displayName": "Allowed locations",
        "strongType": "location"
      }
    }
  }
PARAMETERS
}

resource "azurerm_resource_group" "policy" {
  name     = "test-resources"
  location = "West Europe"
}

resource "azurerm_resource_group_policy_assignment" "policy" {
  name                 = "example-policy-assignment"
  policy_definition_id = azurerm_policy_definition.policy.id
  resource_group_id    = azurerm_resource_group.policy.id
  description          = "Sample Policy Assignment"
  display_name         = "My Custom Policy Assignment"

  metadata = <<METADATA
    {
    "category": "General"
    }
METADATA

  parameters = <<PARAMETERS
{
  "allowedLocations": {
    "value": [ "Central india" ]
  }
}
PARAMETERS

}
