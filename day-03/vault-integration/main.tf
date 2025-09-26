terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.14.1"
    }
    vault = {
      source  = "hashicorp/vault"
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



data "vault_kv_secret_v2" "db" {
  mount = "secret"
  name  = "database"
}


# # 1) Read secret from Vault ephemerally (KVv2 mount "secret", secret "database")
# ephemeral "vault_kv_secret_v2" "db" {
#   mount = "secret"
#   name  = "database"
# }

# 2) Create RDS using write-only password args (nothing is persisted to state)
resource "aws_db_instance" "db" {
  db_name             = "ntidb"
  engine              = "postgres"
  identifier          = "db2-instance-demo"
  instance_class      = "db.t3.micro"
  publicly_accessible = true
  allocated_storage   = 20
  username            = "appuser"
  skip_final_snapshot = true
  password            = data.vault_kv_secret_v2.db.data["password"]

  # password_wo         = ephemeral.vault_kv_secret_v2.db.data["password"]
  # password_wo_version = 2  # bump if you rotate/changes the source value so TF knows to resend
}

