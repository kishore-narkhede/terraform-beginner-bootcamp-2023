# Change made on Github
terraform {

  cloud {
    organization = "KishoreOrg"

    workspaces {
      name = "terra-house-1"
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.19.0"
    }

  }
}

provider "random" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  length  = 32
  special = false
  lower   = true
  upper   = false
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket
resource "aws_s3_bucket" "example" {
  # Bucket naming rules
  # https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
  bucket = random_string.bucket_name.result

}

# https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string
output "random_bucket_name_name" {
  value = random_string.bucket_name.result
}

