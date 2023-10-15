#!/bin/bash

environment=""

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

aws_region="us-west-1"
s3_bucket_name="tf-${environment}-state-storage-bucket"

read -p "Are you sure you want to proceed with deleteing $s3_bucket_name? (y/n)" response

if [ "$response" == "Y" ] || [ "$response" == "y" ]; then
    echo "Proceeding with s3 backend bucket delete"
else
    echo "Operation canceled. Will not delete s3 backend bucket"
    exit 1
fi

# delete terraform backend bucket
if aws s3api head-bucket --bucket $s3_bucket_name --region $aws_region 2>/dev/null; then
    aws s3 rb s3://$s3_bucket_name --force
fi