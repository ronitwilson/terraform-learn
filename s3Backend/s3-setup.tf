provider "aws" {
  region = "us-east-1" # Change this to your desired region
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "ronterrastate260225"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "Dev"
  }
  versioning {
    enabled = true
  }
}

# Backend configuration for S3 with DynamoDB lock
resource "aws_s3_bucket_server_side_encryption_configuration" "bucketEncrypt" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

# Create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraformstatelocks"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  hash_key = "LockID"

  tags = {
    Name        = "Terraform State Lock Table"
    Environment = "Terraform"
  }
}


terraform {
  backend "s3" {
    bucket         = "ronterrastate260225"
    key            = "terraform/state.tfstate" # Path to the state file
    region         = "us-east-1"               # AWS region
    dynamodb_table = "terraformstatelocks"
    encrypt        = true
  }
}