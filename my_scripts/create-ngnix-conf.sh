#!/bin/bash

# Default server name
server_name="peakaltitudestudio.com www.peakaltitudestudio.com;"

# Check for the branch argument
while getopts ":b:" opt; do
  case "$opt" in
    b)
      branch="$OPTARG"
      if [ -n "$branch" ]; then
        server_name="${branch}.peakaltitudestudio.com www.${branch}.peakaltitudestudio.com;"        
      fi
      ;;
  esac
done

# Nginx configuration
config="server {
    listen 80;
    server_name $server_name;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}"

echo "$config" > ./ec2files/${branch}peakaltitudestudio-nginx.conf
