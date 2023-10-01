# Peak Altitude Studio
This is the repository for my website, https://peakaltitudestudio.com

## Steps for creation according to ChatGPT
### Progress
1. Setup Pipeline
    - configure AWS secret key
    - configure Docker username and ghcr token
    - terraform backend bucket via aws s3api
        - backend.tf in pipeline only
2. Configure Terraform for AWS
    - terraform init and apply
        - setup ssh, http, https, port security groups
        - ec2 instance
        - user_data script for docker, nginx and certbot
        - public and elastic ip
3. Create React Application
4. Dockerize Application
    - push to ghcr.io with tag
5. EC2 Instance Setup
    - configure ssh key in github secrets
6. Direct DNS to EC2 Public IP
7. Nginx Configuration
    - create nginx.conf for ec2
        - point at DNS
    - use certbot to create ssl
    - pipeline for certbot renewal

By: Adam Larson