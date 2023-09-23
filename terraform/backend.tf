terraform {
  backend "s3" {
    bucket         = "tf-s3-state-storage-bucket"
    key            = "state-storage/terraform.tfstate"
    encrypt        = true
    region         = "us-west-1"
  }
}