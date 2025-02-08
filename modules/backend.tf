
terraform {
  backend "s3" {
    bucket         = "ronterrastate260225"
    key            = "terraform/keys" # Path to the state file
    region         = "us-east-1"               # AWS region
    encrypt        = true
  }
}