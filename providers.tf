terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.42.0"
    }

    aws = {
      source = "hashicorp/aws"
      version = "4.54.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  subscription_id = "acadd71a-590b-48a8-8ca2-71d7becbdf29"
  features {
    
  }
  
}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}