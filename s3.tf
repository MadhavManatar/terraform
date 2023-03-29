provider "aws" {

    region = "us-east-2"

}

resource "aws_s3_bucket" "demo2" {
  bucket = var.bucket
}

resource "aws_s3_bucket_acl" "demo2" {
    bucket = var.bucket
    acl = "private"
}

resource "aws_s3_bucket_versioning" "demo2" {
    bucket = var.bucket
    versioning_configuration {
        status = "Enabled"
    }
}
