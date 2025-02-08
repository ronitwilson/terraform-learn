variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = [
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"] }
  ]
}

resource "aws_security_group" "example" {
  name        = "example"
  description = "Example security group"
  vpc_id      = "vpc-0be83fb4blbc4b4f1"

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
}

resource "aws_instance" "jenkins_instance" { 
    for_each = { for instance in var.instance_details : instance.instance_name => instance } 
    instance_type = "t2.micro" 
    associate_public_ip_address = true 
    tags = { 
        Name = each.key 
    } 
    ami = each.value.ami_id 
} 

variable "instance_details" { 
    type = list(object({ 
        instance_name = string 
        ami_id = string 
    }))
    default = [ 
        { instance_name = "Ubuntu_04.04", ami_id = "ami-0e2c8caa4b6378d8c" }, 
        { instance_name = "Amazon Linux", ami_id = "ami-05576a079321f21f8" } 
    ] 

} 
