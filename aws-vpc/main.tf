terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

  default_tags {
    tags = {
      Environment = "Dev"
      ManagedBy   = "Terraform"
    }
  }
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    "Name" = "my_vpc"
  }
}

# Create a private subnet
resource "aws_subnet" "private_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.1.0/24"
    tags = {
      "Name"="private-subnet"
    }
}
# Create a public subnet
resource "aws_subnet" "public_subnet" {
    vpc_id            = aws_vpc.my_vpc.id
    cidr_block        = "10.0.2.0/24"
    tags = {
      "Name"="public-subnet"
    }
}

# Create an Internet Gateway

resource "aws_internet_gateway" "my_internet_gateway" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    "Name" = "my_internet_gateway"
  }
}

# Create a route table
resource "aws_route_table" "my-route-tabel" {
  vpc_id = aws_vpc.my_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_internet_gateway.id
  }
}
resource "aws_route_table_association" "public-sub" {
  route_table_id = aws_route_table.my-route-tabel.id
  subnet_id = aws_subnet.public_subnet.id
}