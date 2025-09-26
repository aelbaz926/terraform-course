terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
  }
}

provider "aws" {
  region = "us-east-1" # AWS ACCOUNT ID:12345
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "mykey" {
  key_name   = "deployer-key-${var.environment}"
  public_key = file("${path.module}/terraform-ec2.pub")
}

resource "aws_security_group" "my_security_group" {
  name        = "my-security-group-${var.environment}"
  description = "Allow SSH and HTTP traffic"
  # Allow inbound traffic
  ingress {
    from_port   = 22 # SSH port
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere
  }
  ingress {
    from_port   = 80 # HTTP port
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere
  }
  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"          # All protocols
    cidr_blocks = ["0.0.0.0/0"] # Allow all outbound traffic
  }
  depends_on = [aws_key_pair.mykey]
}


resource "aws_instance" "webserver" {
  ami           = data.aws_ami.ubuntu.id
  security_groups = [aws_security_group.my_security_group.name]
  instance_type   = var.instance_type
  key_name        = aws_key_pair.mykey.key_name
  user_data       = file("${path.module}/init.sh")

  tags = {
    Name        = "webserver--${var.environment}"
    Environment = var.environment
  }
}


variable "instance_type" {
  description = "instance type"
  type        = string
  default     = "t3.micro"
}

variable "environment" {
  description = "Environment Name"
  type        = string
}

output "ec2_public_ip" {
  value = aws_instance.webserver.public_ip
}

