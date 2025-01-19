resource "aws_instance" "web" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  key_name = "${var.key_name}"
  availability_zone = "${var.availability_zone_id}"
  subnet_id = "${var.subnet_id}"

  tags = {
    Name = "HelloWorldTerraform"
  }
}

vpc_id = "vpc-078bec5495183fe04"
subnet_id = "subnet-057f682c075af6a93"
availability_zone_id = "us-east-1c"
ami_id = "ami-01816d07b1128cd2d"
key_name = ""


