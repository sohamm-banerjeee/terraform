terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.50.0"
    }
  }
}

provider "azurerm" {
    features {}
	subscription_id   = "433b320d-e34f-4e4f-b4b0-43425f4ef986"
}