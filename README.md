# Terraform ECS Batch Pipeline

---

## Project Overview

This Terraform project provisions a complete infrastructure setup for running containerized batch jobs on AWS using ECS and Fargate. It includes networking, security, IAM roles, VPC endpoints, logging, autoscaling, and S3/SQS integrations — supporting a scalable and secure batch processing pipeline triggered by queue events.

---

## Resources Created

- ECR Repository (for batch processing container image)
- Custom VPC with private and endpoint subnets  
- Route tables and VPC gateway  
- VPC Endpoints (SQS, S3, CloudWatch, ECR)  
- ECS Cluster and Fargate Service  
- CloudWatch Log Group  
- IAM Roles for ECS Task and Execution  
- S3 buckets (source + destination)  
- SQS Queue for triggering ECS tasks  
- CloudWatch Alarms and Autoscaling policies based on SQS queue length  
- Security Groups for ECS and endpoints  

---

## Usage

### Prerequisites

- A remote backend and state lock table must be provisioned and accessible (S3 bucket and DynamoDB table) before running the pipeline.  
- **The ECR repository is provisioned as part of this project. The GitHub Actions CI/CD pipeline will build and push the Docker image from `ecr_repo/docker_app/` to this repository before ECS deployment.**

### 1. Environment Variables

The GitHub Actions CI/CD pipeline uses the following secrets:

- `AWS_ACCESS_KEY_ID`  
- `AWS_SECRET_ACCESS_KEY`  

### 2. Deployment

Clone the repository and push changes to trigger the CI/CD workflow.

---

## CI/CD Pipeline

A GitHub Actions workflow (`.github/workflows/deploy.yml`) automates the deployment of both the ECR repository and the ECS batch pipeline, including building and pushing the Docker image.

The pipeline:

- Checks out the repository  
- Sets up Terraform and AWS credentials using GitHub secrets  
- Sets environment variables including project URL and environment-specific Terraform variable files  
- **Deploys the ECR infrastructure**: initializes, validates, plans, and applies Terraform in `ecr_repo/env`  
- **Builds and pushes the Docker image** from `ecr_repo/docker_app` to the created ECR repository  
- **Deploys the ECS batch pipeline**: initializes, validates, plans, and applies Terraform in `ecs_batch_pipeline` with the ECR image URI passed as a variable  

This setup ensures that the ECR repo and Docker image are ready before ECS deployment, enabling ECS tasks to pull the correct container image for batch processing.

It uses GitHub Actions environment secrets for secure authentication.

The `PROJECT_URL` variable is injected automatically by the pipeline and passed to Terraform for tagging purposes.

---

## Variables

Refer to the [docs/variables.md](docs/01_variables.md) file for full variable definitions, descriptions, and usage examples.

---

## Tags

All AWS resources are consistently tagged for clarity, traceability, and ownership. Tags include:

| Key           | Value                                                                                 |
|---------------|---------------------------------------------------------------------------------------|
| `Environment` | `<environment>` (e.g., `production`, `dev`, `staging`)                                |
| `Owner`       | `<team-name>` (e.g., `devops-team`, `backend-team`)                                   |
| `Project`     | `<project-name>`                                                                      |
| `Name`        | `<prefix-name> + <resource-type>` (e.g., `terraform_network_architecture-bastion-sg`) |
| `project_url` | `<project-repo-url>`                                                                  |

---

## Outputs

Refer to the [docs/outputs.md](docs/02_outputs.md) file for all exported values, including resource IDs, ARNs, and endpoint names.

---

## Additional Notes

- Make sure AWS credentials and Terraform version are aligned with your CI/CD setup.  
- Batch jobs are triggered via SQS. Ensure your application publishes messages to the correct queue format.  
- ECS task autoscaling is based on CloudWatch alarms monitoring `ApproximateNumberOfMessagesVisible` in the SQS queue. This ensures the number of running tasks increases when there are unprocessed messages and scales down when idle.
