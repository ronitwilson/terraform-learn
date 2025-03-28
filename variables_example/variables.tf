variable "vpc_id" {
  description = "VPC ID for AWS resources."
}

variable "availability_zone_id" {
  description = "AZ used to create EC2 instances."
}

variable "subnet_id" {
  description = "Subnet for EC2 instances."
}

variable "ami_id" {
  description = "AMI ID for EC2 instances."
}

variable "key_name" {
  description = "Key Name for EC2 Instance."
}