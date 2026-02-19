terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Explicitly set the region in the provider 
provider "aws" {
  region = "ap-south-1" # Or your preferred region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"]
}

data "aws_vpc" "default" {
  default = true 
}

data "aws_subnets" "default"{
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_security_group" "allowssh" {
  name        = "allow_ssh_traffic"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = file("../terra-ec2.pem.pub")
}

resource "aws_instance" "ec2" {
  
  ami                    = data.aws_ami.ubuntu.id # FIXED: Added .id
  instance_type          = var.ec2_inststance_type
  vpc_security_group_ids = [aws_security_group.allowssh.id]
  
  # This picks the first subnet ID from the list found by the data source
  subnet_id              = data.aws_subnets.default.ids[0]
  key_name               = aws_key_pair.ec2_key_pair.key_name

   root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  } 

  tags = {
    Name = "Terraform ec2"
  }
}

output "ubuntu_user_name" {
  description = "Command to login into the ec2"
  value = "ssh -i ../terra-ec2.pem ubuntu@${aws_instance.ec2.public_ip}"
}
output "ec2_public_dns" {
  description = "Here is your dns"
  value = aws_instance.ec2.public_dns
}