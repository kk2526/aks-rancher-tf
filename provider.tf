terraform {
    backend "s3" {
    bucket = "tfstate"
    key = "infrastructure/rancher2aks/lab-terraform.tfstate"

    endpoint = "https://minio.com/"

    access_key="minio-poc"
    secret_key="Minio321"

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
    # rancher2 = {
    #   source = "rancher/rancher2"
    #   version = "~>1.22.0"
    # }
  }
}

provider "azurerm" {
  features {}
}

