# Peak Altitude Studio
This is the repository for my website, https://peakaltitudestudio.com

## Steps for creation according to ChatGPT
### Step 1: Set Up Your Development Environment
[x] Ensure you have Node.js and npm installed on your Macbook.
    [x] Upgrade if needed
[x] Install VS Code for your Integrated Development Environment (IDE).
[x] Create and AWS Account
    [x] Configure IAM Group, Policies, and User
[x] Set up AWS CLI on your machine for managing AWS resources.

### Step 2: Create a React Application
[x] Use create-react-app or your preferred method to initialize a React project.
[] Initial Cleanup
    [] Remove any default code in src/App.js and start building your custom components.
    [] Set up your project's CSS and styling framework if needed.
    [] Configure any additional dependencies required for your specific project, such as video player libraries.
[] Set up your project structure, including folders for components, pages, and assets.

### Step 3: Design the Main Page
- Create a main page layout that includes your 4K video player.
- Set up the necessary React components and CSS styles.
- Use a popular video player library like react-player to integrate the player.
- Fetch videos from AWS S3 using the AWS SDK or API calls.

### Step 4: Create the Customer Download Page
- Design a page where customers can enter codes to download their videos.
- Implement a form for customers to input their codes.
- Set up a Python backend (e.g., Flask or Django) to handle code validation and video retrieval.

### Step 5: AWS Setup
- Create an AWS S3 bucket to store your videos.
- Set up an AWS Lambda function to handle video processing or other backend tasks.
- Configure AWS IAM roles for necessary permissions.
- Optionally, use AWS CloudFront for content delivery and AWS API Gateway for serverless APIs.

### Step 6: Dockerize Your Application
- Create a Dockerfile for your React application.
- Dockerize your Python backend if you're using one.
- Build and tag Docker images for both frontend and backend.

### Step 7: Infrastructure as Code with Terraform
- Set up a Terraform project to manage your AWS infrastructure.
- Define resources like S3 buckets, Lambda functions, IAM roles, and API Gateway.
- Configure Terraform variables and providers for your AWS environment.

### Step 8: Deploy Your Application
- Use Docker Compose or an orchestration tool like Kubernetes to manage your Docker containers.
- Deploy your application to an AWS EC2 instance or a container service like AWS ECS or Fargate.
- Deploy your infrastructure using Terraform.

### Step 9: Domain Setup
- Register a domain name for your videography website.
- Configure DNS settings to point to your AWS resources.

### Step 10: Testing and Optimization
- Thoroughly test your website's functionality and responsiveness.
- Optimize your website for performance and security.
- Implement logging and monitoring using AWS CloudWatch or other tools.

### Step 11: Continuous Integration and Deployment (CI/CD)
- Set up a CI/CD pipeline using tools like Jenkins, Travis CI, or AWS CodePipeline.
- Automate the deployment process for your website updates.

### Step 12: Launch and Promote Your Website
- Launch your website and make it publicly accessible.
- Promote it through social media, SEO, and other marketing channels.
- Provide customer support and gather feedback for improvements.

By: Adam Larson