#!/bin/bash

environment="local"

# Parse command-line options
while getopts "e:env:" opt; do
  case $opt in
    e | env)
      environment="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

echo "env was set to: ${environment}"

if [ -d ../terraform ]; then
    cd ../terraform
elif [ -d ./terraform ]; then
    cd terraform
else
    echo "Could not find terraform directory, exiting"
    exit 1
fi

aws_region="us-west-1"
s3_bucket_name="tf-${environment}-state-storage-bucket"

cd ../terraform
# 2>/dev/null keeps it from erroring and continues execution
if aws s3api head-bucket --bucket $s3_bucket_name --region $aws_region 2>/dev/null; then
    echo "S3 bucket exists, continuing with destroying."
else
    echo "Exiting... because S3 Bucket did not exist, meaning no backend state exists, must destory any hanging resources manually"
    exit 1
fi
cp ./pipeline-tf-backend/${environment}devbackend.tf ./backend.tf
terraform init
terraform destroy --auto-approve
rm ./backend.tf
rm ./terraform.tfstate
rm ./terraform.tfstate.backup
rm -r .terraform