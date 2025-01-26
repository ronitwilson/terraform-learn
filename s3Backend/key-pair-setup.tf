resource "tls_private_key" "ec2-key" {
  algorithm = "ED25519"
}

resource "aws_key_pair" "access-key-pair" {
  key_name   = "access-key"
  public_key = tls_private_key.ec2-key.public_key_openssh
}

output "private_key_pem" {
  value     = tls_private_key.ec2-key.private_key_pem
   sensitive = true
}