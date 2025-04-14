provider "aws" {
    region = "us-east-1" # Change to your desired region
}

resource "tls_private_key" "ssh_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
    key_name   = "generated-ssh-key"
    public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_security_group" "ssh_access" {
    name_prefix = "allow-ssh-"
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
    security_group_id = aws_security_group.ssh_access.id
    from_port         = 22
    to_port           = 22
    ip_protocol          = "tcp"
    cidr_ipv4        = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all_egress" {
    security_group_id = aws_security_group.ssh_access.id
    ip_protocol       = -1
    cidr_ipv4        = "0.0.0.0/0"
}

resource "aws_instance" "ec2_instances" {
    count         = 3
    ami           = "ami-00a929b66ed6e0de6" # Replace with your desired AMI ID
    instance_type = "t2.micro"             # Change to your desired instance type
    key_name      = aws_key_pair.generated_key.key_name
    vpc_security_group_ids = [aws_security_group.ssh_access.id]

    tags = {
        Name = "Ansible-${count.index == 0 ? "Master" : "Node-${count.index}"}"
    }

    provisioner "remote-exec" {
        inline = [
            "ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa -q -N ''"
        ]

        connection {
            type        = "ssh"
            user        = "ec2-user" # Replace with the appropriate username for your AMI
            private_key = tls_private_key.ssh_key.private_key_pem
            host        = self.public_ip
        }
    }
}