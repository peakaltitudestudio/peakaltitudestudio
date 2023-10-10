# Peak Altitude Studio
This is the repository for my website, https://peakaltitudestudio.com

## Steps for creation according to ChatGPT
### Progress
1. Setup Pipeline
    - configure AWS secret key
    - configure Docker username and ghcr token
    - terraform backend bucket via aws s3api
        - backend.tf in pipeline only
    - hosted zone
        - manually created for reusable NS records
         - copy zone_id into terraform variables
2. Configure Terraform for AWS
    - terraform init and apply
        - setup ssh, http, https, port security groups
        - ec2 instance
        - user_data script for docker, nginx <s>and certbot</s>
        - public and elastic ip
        - vpc, internet gateway, subnets
        - route 53 with A and CNAME records
        - load balancer
        - ACM
3. Create React Application
4. Dockerize Application
    - push to ghcr.io with tag
5. EC2 Instance Setup
    - configure ssh key in github secrets
6. Setup Loab Balancer and Route 53 <s>Direct DNS to EC2 Public IP</s>
    - create load balancer
    - A record from step 2 should point to lb
    - security groups http/https inbound and outbound permissions
7. Nginx Configuration
    - create nginx.conf for ec2
        - point at DNS
    - use ACM for ssl cert on load balancer
    - <s>use certbot to create ssl</s>
    - <s>pipeline for certbot renewal</s>


By: Adam Larson