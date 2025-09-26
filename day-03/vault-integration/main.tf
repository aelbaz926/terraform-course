terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.14.1"
    }
    vault = {
      source = "hashicorp/vault"
      version = "5.3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "<>:8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "<>"
      secret_id = "<>"
    }
  }
}


data "vault_generic_secret" "db" {
  path = "secret/data/database"
}

resource "aws_db_instance" "example" {
  identifier        = "example-db"
  engine            = "mysql"
  username          = "admin"
  password          = data.vault_generic_secret.db.data["password"]
  instance_class    = "db.t3.micro"
  allocated_storage = 20
}
