

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}


resource "azurerm_key_vault" "example" {
  name                        = "example-vault-123"
  location                    = "West US"
  resource_group_name         = azurerm_resource_group.Vegetagrp.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  purge_protection_enabled    = true
  soft_delete_retention_days  = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
      "list",
      "create",
      "delete"
    ]

    secret_permissions = [
      "get",
      "list",
      "set",
      "delete"
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "example-secret"
  value        = "supersecretvalue"
  key_vault_id = azurerm_key_vault.example.id
}
