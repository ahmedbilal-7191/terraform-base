terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0" # Specify the desired version constraint
    }
  }
}
provider "aws" {
  region = "us-west-2"
}
resource "random_id" "bucket_suffix" {
  byte_length = 4
}
resource "aws_s3_bucket" "dynamic_s3_buckets" {
  for_each = var.buckets
  bucket = "${each.key}-${random_id.bucket_suffix.hex}"
  tags = {
    Name = each.key
    Description = each.value
  }
}
output "bucket_names" {
  value = [for bucket in aws_s3_bucket.dynamic_s3_buckets: bucket.bucket ]
}
