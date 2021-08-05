provider "aws" {
  region = "ap-south-1"
  profile = "terraform"

}

resource "aws_iam_user" "user" {
  name = "srv_${var.bucket_name}"
}

# generate keys for service account user
resource "aws_iam_access_key" "user_keys" {
  user = "${aws_iam_user.user.name}"
}

#############################################

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket =  module.s3_bucket.s3_bucket_id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_user.user.arn}"
      },
      "Action": [ "s3:*" ],
      "Resource": [
        "${module.s3_bucket.s3_bucket_arn}",
        "${module.s3_bucket.s3_bucket_arn}/*"
      ]
    }
  ]
}
EOF
}

####################################################################
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "${var.bucket_name}"
  acl    = "private"

  versioning = {
    enabled = false
  }

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

}