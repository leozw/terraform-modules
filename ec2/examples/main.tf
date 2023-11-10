provider "aws" {
  region  = ""
  profile = ""
}  

## EC2
module "ec2" {
  source = "git@github.com:elvenworks-ps/professional-services.git//terraform-modules/ec2?ref=main"

  name                        = "ec2-terraform"
  vpc_security_group_ids      = ["sg-abdbacabc"]
  instance_type               = "t3.micro"
  associate_public_ip_address = false
  key_name                    = "key"
  eip                         = false
  subnet_id                   = "subnet-0397a0a1714227ce6"
  image_name                  = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  owner                       = "099720109477"

  root_block_device = [
    {
      volume_type = "gp3"
      volume_size = 10
      tags = {
        Name = "root-block"
      }
    },
  ]
  tags = {
    Environment = "Development"
  }
}