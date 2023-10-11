# Needs to be moved to same directory as main.tf in the pipeline
terraform {
  backend "s3" {
    bucket         = "tf-main-state-storage-bucket"
    key            = "state-storage/terraform.tfstate"
    encrypt        = true
    region         = "us-west-1"
  }
}