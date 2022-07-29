packer {
  required_plugins {
    amazon = {
      version = ">= 0.0.2"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}


source "amazon-ebs" "ubuntu" {
  ami_name      = "lab_ami-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "eu-west-1"
  vpc_id        = "vpc-06705f43e25893c54"
  subnet_id     = "subnet-072a67f738125b7c4"
  deprecate_at  = "2023-07-29T23:59:59Z"




  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["099720109477"]
  }
  ssh_username = "ubuntu"
}

build {
  name = "learn-packer"
  sources = [
    "source.amazon-ebs.ubuntu"
  ]


  provisioner "ansible" {
    playbook_file = "./playbooks/apache2.yml"
  }
}
