#This is only meant to be run on the pipeline to preserve state
provider "aws" {
  region = "us-west-1"
}

resource "aws_s3_bucket" "tf-s3-state-storage" {
  bucket = "tf-ci-state-storage-bucket"
}