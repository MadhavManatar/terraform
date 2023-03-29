provider "aws" {
    region = "us-east-2"
}


resource "aws_s3_object" "object"{
    bucket = "demobucket0401"
    key = "new_data"
    source = "/home/madhav-manatara/Desktop/terraform/s3/s3.tf"
}
