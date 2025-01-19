resource "aws_instance" "ansible" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  count         = 3
  
  tags = {
    Name = var.instance_tags[count.index]
  }
}


variable "instance_tags" {
    default = [
    "ansible-masters",   # Instance 1
    "ansible-client1",   # Instance 2
    "ansible-client2"    # Instance 3
    ]
  }