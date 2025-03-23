resource "aws_security_group" "infra_sg" {
  name = "sg_terra"
  description = "security group."
}

resource "aws_security_group_rule" "ssh_ingress_access" {
  type = "ingress"
  from_port = 22
  to_port = 22
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ] 
  security_group_id = "${aws_security_group.infra_sg.id}"
}

resource "aws_security_group_rule" "egress_access" {
  type = "egress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  cidr_blocks = [ "0.0.0.0/0" ]
  security_group_id = "${aws_security_group.infra_sg.id}"
}

resource "aws_instance" "ansible" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"
  count         = 3

  tags = {
    Name = var.instance_tags[count.index]
  }

  vpc_security_group_ids = [aws_security_group.infra_sg.id]
  key_name = aws_key_pair.access-key-pair.key_name
}


variable "instance_tags" {
    default = [
    "ansible-masters",   # Instance 1
    "ansible-client1",   # Instance 2
    "ansible-client2"    # Instance 3
    ]
  }
