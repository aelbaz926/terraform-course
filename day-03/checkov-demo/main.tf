provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "bad_sg" {
  name        = "bad-sg"
  description = "Wide open SG"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # insecure: open to internet
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# resource "aws_security_group" "good_sg" {
#   name        = "good-sg"
#   description = "Allow only HTTP from internet and SSH from office"

#   ingress {
#     description = "Allow HTTP from anywhere"
#     from_port   = 80
#     to_port     = 80
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   # SSH only from your IP (replace with actual)
#   ingress {
#     description = "Allow SSH from my IP"
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["203.0.113.25/32"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }
