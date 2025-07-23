# Terraform ECS Batch Pipeline

---

## Project Overview

This Terraform project provisions a complete infrastructure setup for running containerized batch jobs on AWS using ECS and Fargate. It includes networking, security, IAM roles, VPC endpoints, logging, autoscaling, and S3/SQS integrations — supporting a scalable and secure batch processing pipeline triggered by queue events.

---

## Resources Created

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
- An existing ECR repository must be available and contain the Docker image used by the ECS task definition.

### 1. Environment Variables

The GitHub Actions CI/CD pipeline uses the following secrets:

- `AWS_ACCESS_KEY_ID`  
- `AWS_SECRET_ACCESS_KEY`  

### 2. Deployment

Clone the repository and push changes to trigger the CI/CD workflow.

---

## CI/CD Pipeline

A GitHub Actions workflow (`.github/workflows/deploy.yml`) is included to automate Terraform validation and deployment.

The pipeline:
- Initializes Terraform  
- Formats and validates Terraform code  
- Generates and applies a Terraform plan  

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
