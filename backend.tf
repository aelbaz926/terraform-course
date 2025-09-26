terraform {
  backend "s3" {
    bucket = "nti-s3-1234567"
    key    = "nti/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
