
terraform {
  backend "s3" {
    bucket = "remote-backend-terraform-store" # Manuualy created 
    key    = "terraform.tfstate"
    region = "ca-central-1"
  }
}
