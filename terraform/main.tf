provider "aws" {
  region = local.region

  # Make it faster by skipping something
  #skip_metadata_api_check     = true
  #skip_region_validation      = true
  #skip_credentials_validation = true
  #skip_requesting_account_id  = true
}

locals {
  region      = "us-east-1"
}

resource "random_string" "this" {
  length = 6
  special = false
  upper = false
}

module "s3-bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.15.1"

  bucket        = "mastodon-config-backup-${random_string.this.id}"
  #force_destroy       = true
}
