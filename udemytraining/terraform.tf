terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.30.0"
    }
  }
}

provider "azurerm" {
  features {}
  client_id = "9862f5e9-6c85-46d2-b92a-c077496f7d35"
  client_secret = "if08Q~OjvzLYM5fQtV1Uwi83T1KQL0WDe1Hmpa6Z"
  tenant_id = "f9490d77-f757-4590-9b75-64b458fc3df8"
  subscription_id = "629aa083-5667-47f4-b94b-81422ace6d99"
}
