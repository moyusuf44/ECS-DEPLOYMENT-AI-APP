terraform {
  required_providers {
    aws = {
      source    = "hashicorp/aws"
      version   = "~> 5.0"
    }
    cloudflare  = {
      source    = "cloudflare/cloudflare"
      version   = "~> 5.0"
    }
  }
}
provider "aws" {
  region = var.region_id
}
provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
