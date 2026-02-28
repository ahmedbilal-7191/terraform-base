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
resource "aws_s3_bucket" "lifecycle_bucket" {
  bucket = "lifecycle-managed-bucket-${random_id.bucket_suffix.hex}"
}
resource "aws_s3_bucket_lifecycle_configuration" "lifecycle_bucket_config" {
  bucket = aws_s3_bucket.lifecycle_bucket.id
  rule {
    id = "transition-to-ia-and-glacier"
    status = "Enabled"
    filter {}
    transition {
      days = 30
      storage_class = "STANDARD_IA"
    }
    transition {
      days = 90
      storage_class = "GLACIER"
    }
  }
}
