#!/bin/bash

s3_bucket_name=''

# Check for the bucket argument
while getopts ":b:" opt; do
  case "$opt" in
    b)
      s3_bucket_name="$OPTARG"
      ;;
  esac
done

# terraform backend contents
contents="# Needs to be moved to same directory as main.tf in the pipeline
terraform {
  backend \"s3\" {
    bucket         = \"$s3_bucket_name\"
    key            = \"state-storage/terraform.tfstate\"
    encrypt        = true
    region         = \"us-west-1\"
  }
}"

echo "$contents" > ./backend.tf
