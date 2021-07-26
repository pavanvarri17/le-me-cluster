provider "aws" {
  region = "ap-south-1"
  profile = "terraform"

}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-testing-purpose-poc-bucket"
  acl    = "private"

  versioning = {
    enabled = false
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}