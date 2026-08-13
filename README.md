# AI Application AWS Deployment

## Overview

This project deploys a containerised **Python FastAPI AI application** to **AWS ECS Fargate** using **Terraform** and **GitHub Actions CI/CD**.

The application integrates with the **OpenAI API** and is exposed through an Application Load Balancer with Cloudflare DNS and HTTPS.

### Technologies

* AWS ECS Fargate, ECR, VPC, ALB, ACM
* Terraform
* Docker
* Python / FastAPI
* OpenAI API
* GitHub Actions
* Cloudflare
* Amazon S3 / DynamoDB
* Linux / Bash

---

## Architecture

User > HTTPS > Cloudflare DNS > ALB > AWS ECS Fargate > FastAPI Container > OpenAI API

The Docker image is stored in **Amazon ECR** and pulled by ECS Fargate during deployment.

---

## Application

The application is built with FastAPI and provides health checks, running checks and an AI endpoint.

```text
GET /health
```

```json
{
  "status": "ok"
}
```

The OpenAI API key is supplied through environment variables rather than being stored in the source code.

---

## Docker

The application uses a **multi-stage Docker build** to separate the build and runtime environments and reduce the final image size.

Build:

```bash
docker build -t ai-app .
```

Run locally:

```bash
docker run --env-file .env -p 8080:8000 ai-app
```

Test:

```text                             
http://localhost:8080/docs   http://localhost:8080/chat   http://localhost:8080/health
```

---

## Terraform Infrastructure

Terraform manages the AWS infrastructure through reusable modules, including:

* VPC and public subnets
* ECR repository
* ECS Fargate cluster and service
* Application Load Balancer and Security groups
* ACM certificate
* Cloudflare DNS

Terraform allows the entire environment to be recreated without manually configuring each AWS service.

### Remote State

Terraform state is stored remotely using:

* **Amazon S3** — state storage
* **Amazon DynamoDB** — state locking

The backend resources should be created separately and should not be destroyed during the normal application lifecycle.

---

## CI/CD

GitHub Actions automates the deployment process.

The workflow can run automatically on pushes to `main` or manually using **workflow dispatch**.

Checkout > AWS Authentication > ECR Login > Docker Build > Push Image to ECR > Terraform Deployment > ECS Runs New Image 

However it should be known this project has seperate actions for these workflows and must be done in order.

This removes the need to manually build and push the Docker image after every change.

---

## Secrets

Sensitive values are stored using GitHub Actions Secrets and environment variables.

```text
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
CLOUDFLARE_API_TOKEN
OPENAI_API_KEY
```

`.env` is excluded using `.gitignore` and `.dockerignore`. 

API keys should never be committed to Git.

---

## Local Development

### Requirements

* Git
* Docker
* Python
* Terraform
* AWS CLI
* AWS account
* Cloudflare account/domain
* OpenAI API key

Install Python dependencies:

```bash
pip install -r requirements.txt
```

Create `.env`:

```text
OPENAI_API_KEY=your-api-key
```

Run the application:

```bash
uvicorn main:app --host 0.0.0.0 --port 8000
```

Test:

```text
http://localhost:8000/health
```

---

## Terraform Deployment

```bash
cd Infrastructure-terra

terraform init
terraform validate
terraform plan
terraform apply
```

Terraform provisions the required AWS infrastructure.

Once the GitHub secrets are configured, deployment can also be performed through:

```text
GitHub → Actions → Workflow → Run workflow
```

---

## Security

The project uses several security practices:

* API credentials stored outside source code
* ECS tasks accessed through the ALB rather than directly
* HTTPS provided through AWS ACM
* Terraform state stored remotely
* DynamoDB state locking
* Infrastructure managed through version-controlled Terraform

For a production deployment, API credentials could be moved to **AWS Secrets Manager** and ECS tasks could be placed in private subnets.

---

# Troubleshooting

### Terraform Provider Errors

If the provider lock file or installed providers are out of date:

```bash
terraform init -upgrade
```

### ECS Task Fails

Check the ECS service events and verify:

* ECR image/tag exists
* Container and target-group ports match
* Security groups allow required traffic
* Task execution role has the required permissions

```bash
aws ecs describe-services \
  --cluster <cluster-name> \
  --services <service-name>
```

### ECR Image Pull Errors

If ECS cannot pull the image, check the ECR repository, image tag, execution-role permissions and AWS networking.

### OpenAI API Errors

Check:

* `OPENAI_API_KEY` is present
* The API key is valid
* The OpenAI account has available API credit
* Application logs for the actual API error

### Cloudflare 522

A 522 means Cloudflare cannot establish a connection to the AWS endpoint.

Check:

* ALB is running
* ECS targets are healthy
* DNS points to the correct ALB
* Security groups allow the required traffic
* Cloudflare proxy configuration

---

## Future Improvements

* ECS auto scaling
* CloudWatch monitoring and alarms
* Better application logging/error handling
* Stricter IAM permissions
* Private ECS subnets with NAT
* AWS Secrets Manager
* Container vulnerability scanning
* Production authentication
* Automated Terraform deployment

---

## Skills Demonstrated

**AWS · Terraform · Docker · Python · FastAPI · OpenAI API · GitHub Actions · CI/CD · Linux · Bash · AWS Networking · ECS · ECR · Cloudflare · HTTPS/TLS · Infrastructure as Code · Remote State**

---

## Author

**Mohamed Mahmoud Yusuf**


