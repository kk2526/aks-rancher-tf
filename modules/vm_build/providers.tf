terraform {
    backend "s3" {
    bucket = "tfstate"
    key = "terraform.tfstate"

    endpoint = "http://127.0.0.1:9000"

    access_key="minioadmin"
    secret_key="minioadmin"

    region = "main"
    skip_credentials_validation = true
    skip_metadata_api_check = true
    skip_region_validation = true
    force_path_style = true
  }
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}
