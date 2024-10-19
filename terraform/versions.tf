terraform {
  required_version = ">= 0.13"
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    b2 = {
      source = "Backblaze/b2"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }

  backend "s3" {
    bucket = "dzhus-infrastructure"
    key    = "terraform.tfstate"
    region = "eu-west-1"
  }
}
