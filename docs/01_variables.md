# Terraform Variables

This document outlines the input variables used across the Terraform configuration, including both the root module and reusable child modules. Shared variables are defined once to reduce duplication and promote consistency.

---

## 📦 Shared Variables

The following variables are used across multiple modules with consistent definitions:

| Name          | Description                                | Type           | Default    | Required |
|---------------|--------------------------------------------|----------------|------------|----------|
| `name`        | Name prefix for all resources              | `string`       | _n/a_      | ✅ Yes   |
| `tags`        | Additional tags to apply to resources      | `map(string)`  | `{}`       | ❌ No    |
| `environment` | Deployment environment                     | `string`       | `"dev"`    | ❌ No    |
| `project_url` | URL to the GitHub repository               | `string`       | `""`       | ❌ No    |

These variables are defined in each module for flexibility but are functionally identical.

---

## 📁 ECR Project Root Variables (`ecr_repo/env/main.tf`)

| Name     | Description      | Type     | Default | Required |
|----------|------------------|----------|---------|----------|
| `region` | AWS region       | `string` | _n/a_   | ✅ Yes   |

---

## 📁 ECS Project Root Variables (`ecs_batch_pipeline/main.tf`)

| Name                   | Description                                | Type           | Default                           | Required |
|------------------------|--------------------------------------------|----------------|-----------------------------------|----------|
| `cidr_block`           | VPC CIDR block                             | `string`       | `"10.0.0.0/16"`                   | ❌ No    |
| `azs`                  | Availability Zones                         | `list(string)` | `["us-east-1a", "us-east-1b"]`    | ❌ No    |
| `private_subnet_cidrs` | CIDRs for private subnets                  | `list(string)` | `["10.0.1.0/24", "10.0.2.0/24"]`  | ❌ No    |
| `endpoint_subnet_cidrs`| CIDRs for endpoint subnets                 | `list(string)` | `["10.0.11.0/24", "10.0.12.0/24"]`| ❌ No    |
| `sqs_queue_arn`        | SQS queue ARN for IAM policies             | `string`       | `""`                              | ❌ No    |
| `region`               | AWS region                                 | `string`       | `"us-east-1"`                     | ❌ No    |
| `ecr_image`            | ECR image URI for ECS task container       | `string`       | `""`                              | ❌ No    |
| `desired_count`        | Initial desired count of ECS tasks         | `number`       | `1`                               | ❌ No    |
| `min_capacity`         | Minimum ECS task count for autoscaling     | `number`       | `1`                               | ❌ No    |
| `max_capacity`         | Maximum ECS task count for autoscaling     | `number`       | `4`                               | ❌ No    |

---

## 🔹 Module: `cloudwatch`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`, `region`

| Name               | Description                       | Type      | Default | Required | Notes                            |
|--------------------|-----------------------------------|-----------|---------|----------|----------------------------------|
| `sqs_queue_arn`    | ARN of the SQS queue              | `string`  | _n/a_   | ❌ No    | Inherited from root module       |
| `ecs_cluster_name` | Name of the ECS cluster           | `string`  | _n/a_   | ❌ No    | Inherited from root module       |
| `ecs_service_name` | Name of the ECS service           | `string`  | _n/a_   | ❌ No    | Inherited from root module       |
| `min_capacity`     | Minimum number of ECS tasks       | `number`  | _n/a_   | ❌ No    | Inherited from root module       |
| `max_capacity`     | Maximum number of ECS tasks       | `number`  | _n/a_   | ❌ No    | Inherited from root module       |

---

## 🔹 Module: `ecs`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`, `region`

| Name                      | Description                              | Type           | Default | Required | Notes                            |
|---------------------------|------------------------------------------|----------------|---------|----------|----------------------------------|
| `ecr_image`               | ECR image URI for ECS task               | `string`       | _n/a_   | ❌ No    | Inherited from root module       |
| `sqs_queue_url`           | SQS queue URL for batch processing       | `string`       | _n/a_   | ❌ No    | Inherited from root module       |
| `private_subnet_ids`      | List of private subnet IDs               | `list(string)` | _n/a_   | ❌ No    | Inherited from root module       |
| `security_group_id`       | Security Group ID for ECS tasks          | `string`       | _n/a_   | ❌ No    | Inherited from root module       |
| `desired_count`           | Initial desired ECS task count           | `number`       | `1`     | ❌ No    |                                  |
| `task_execution_role_arn` | IAM Role ARN for ECS task execution      | `string`       | _n/a_   | ❌ No    | Inherited from root module       |
| `task_role_arn`           | IAM Role ARN for ECS task                | `string`       | _n/a_   | ❌ No    | Inherited from root module       |

---

## 🔹 Module: `iam`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`

| Name            | Description                      | Type     | Default | Required | Notes                       |
|-----------------|----------------------------------|----------|---------|----------|-----------------------------|
| `sqs_queue_arn` | SQS queue ARN for IAM policy     | `string` | _n/a_   | ❌ No    | Inherited from root module  |

---

## 🔹 Module: `s3`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`

| Name            | Description                                         | Type     | Default | Required | Notes                            |
|------------------|-----------------------------------------------------|----------|---------|---------|----------------------------------|
| `sqs_queue_arn` | ARN of the SQS queue for S3 event notifications     | `string` | `""`    | ❌ No    | Inherited from root module       |
| `filter_prefix` | Optional prefix filter for S3 event notifications   | `string` | `""`    | ❌ No    | Inherited from root module       |

---

## 🔹 Module: `sqs`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`

_No additional module-specific variables._

---

## 🔹 Module: `tags`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`

_No additional module-specific variables._

---

## 🔹 Module: `vpc`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`

| Name                   | Description                        | Type           | Default                            | Required | Notes                            |
|------------------------|------------------------------------|----------------|------------------------------------|----------|----------------------------------|
| `cidr_block`           | VPC CIDR block                     | `string`       | `"10.0.0.0/16"`                    | ❌ No    | Inherited from root module       |
| `azs`                  | Availability Zones                 | `list(string)` | `["us-east-1a", "us-east-1b"]`     | ❌ No    | Inherited from root module       |
| `private_subnet_cidrs` | CIDRs for private subnets          | `list(string)` | `["10.0.1.0/24","10.0.2.0/24"]`    | ❌ No    | Inherited from root module       |
| `endpoint_subnet_cidrs`| CIDRs for endpoint subnets         | `list(string)` | `["10.0.11.0/24","10.0.12.0/24"]`  | ❌ No    | Inherited from root module       |

### 🔹 Sub-Module: `vpc/modules/security-group`

**Uses shared variables:** `name`, `tags`, `environment`, `project_url`

| Name         | Description                                 | Type     | Required   | Notes                            |
|--------------|---------------------------------------------|----------|------------|----------------------------------|
| `vpc_id`     | VPC ID to associate with the security group | `string` | ❌ No      | Inherited from root module       |

---

> ✅ **Note:** Variables without default values must be explicitly set, either in `terraform.tfvars`, via CLI, or by your CI/CD pipeline.
