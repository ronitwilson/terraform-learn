# Retrieve public key from ansible-client1
resource "null_resource" "get_client1_public_key" {
  provisioner "remote-exec" {
    inline = [
      "cat ~/.ssh/id_rsa.pub"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # Replace with the appropriate username for your AMI
      private_key = tls_private_key.ec2-key.private_key_pem
      host        = aws_instance.ansible[1].public_ip
    }
  }

  triggers = {
    public_key = chomp(self.provisioner["remote-exec"][0])
  }
}

# Retrieve public key from ansible-client2
resource "null_resource" "get_client2_public_key" {
  provisioner "remote-exec" {
    inline = [
      "cat ~/.ssh/id_rsa.pub"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # Replace with the appropriate username for your AMI
      private_key = tls_private_key.ec2-key.private_key_pem
      host        = aws_instance.ansible[2].public_ip
    }
  }

  triggers = {
    public_key = chomp(self.provisioner["remote-exec"][0])
  }
}

# Update known_hosts file on ansible-masters
resource "null_resource" "update_master_known_hosts" {
  depends_on = [null_resource.get_client1_public_key, null_resource.get_client2_public_key]

  provisioner "remote-exec" {
    inline = [
      # Add client1's public key to known_hosts
      "echo '${null_resource.get_client1_public_key.triggers.public_key}' >> ~/.ssh/known_hosts",
      # Add client2's public key to known_hosts
      "echo '${null_resource.get_client2_public_key.triggers.public_key}' >> ~/.ssh/known_hosts"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user" # Replace with the appropriate username for your AMI
      private_key = tls_private_key.ec2-key.private_key_pem
      host        = aws_instance.ansible[0].public_ip
    }
  }
}