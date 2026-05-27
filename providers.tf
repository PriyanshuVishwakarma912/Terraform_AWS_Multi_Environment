terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0" # ya jo bhi version aap use kar rahe ho
    }
  }
}


provider "aws" {
  region = "ap-south-1" 
}