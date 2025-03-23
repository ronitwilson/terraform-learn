Terraform state Drift
    someone did a change in the console directly on top of terraform changes
    Modify that tf file to account that change
        **terraform import** that change 
        The details are given in the documentation
```
terraform import aws_security_group_rule.http_ingress_access sg-02e3fbdeb00649570_ingress_tcp_80_80_0.0.0.0/0

```

# State Providers
Many options
    * Databases
    * S3
    * other cloud providers etc

Its called backend

state file pull to see the output 
```
terraform state pull
```

# getting vars in output.tf
these will get printout at the end

# 2 types of provisioners
![terraform provisioners](image.png)

# How to use terraform output
```
output "private_key_pem" {
  value     = tls_private_key.ec2-key.private_key_pem
   sensitive = true
}

and then 
terraform output private_key_pem
```

# Terraform modules
We set the terraform vars file as we want and then we can use the pre set code of the module to perform the given 

* We can get the modules from the local path
* s3
* github

# Terraform Loops
Saw that for each works in a particual way with aws_ingress rules(dynamic block), it accepts list
but with aws_intsance(resource block) it expects a map or set


# Terraform cloud
* ability to run directly from git
* there is a cli tool which gets connected to the backend
* but the actual execution is in the cloud
* so need to set the variables.possibility of terraform vars and environment vars


# Scaning Terraform script
* tool called checkov (https://www.checkov.io/)

# Logging in terraform
Possiblity of using terraform cloud to store the logs
example of using eterrafor cloud