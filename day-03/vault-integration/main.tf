provider "vault" {
  address = "https://vault.example.com"
  token   = var.vault_token
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
