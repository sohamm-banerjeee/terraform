terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.50.0"
    }

   azuread = {
      source = "hashicorp/azuread"
      version = "2.37.2"
    }

  }
}

provider "azurerm" {
    features {}
	subscription_id   = "b73f59a1-f209-4b5d-8fcc-94d59796b84c"
}