resource "null_resource" "copy_file_on_vm" {
    depends_on = [
        aws_instance.terra_instance,
        tls_private_key.ec2-key
    ]
    connection {
        type        = "ssh"
        user   = "ec2-user"
        private_key = tls_private_key.ec2-key.private_key_pem
        host        = aws_instance.terra_instance.public_ip
    }

    provisioner "file" {
        source      = "./files/test.sh"
        destination = "/home/ec2-user/test.sh"
    }

    provisioner "local-exec" {
    command = "echo File copied successfully"
}

    provisioner "remote-exec" {
           inline = [
      "sudo yum update -y",  # For Amazon Linux
      "sudo amazon-linux-extras enable ansible2",
      "sudo yum install -y ansible"
            ]
    }

    triggers = {
        "always_run" = "${timestamp()}"
    }

}