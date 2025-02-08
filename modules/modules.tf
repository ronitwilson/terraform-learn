module "vm" {
  source          = "git::https://github.com/anujdevopslearn/terraform-modules.git//ec2_module"
  security_group_id = "sg-0b54778020d33ba4e"
  subnet_id       = "subnet-02357f6227873982c"
  key_name        = "deployer-key"
  ami_id          = "ami-03c7d01cf4dedc891"
  bucket_name     = "simplilearn-anuj-terraform-modules"
}
