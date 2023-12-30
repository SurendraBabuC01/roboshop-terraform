terraform {
  backend "s3" {
    bucket = "terraform-95"
    key    = "roboshop/dev/terraform.tfstate"
    region = "us-east-1"
  }
}
