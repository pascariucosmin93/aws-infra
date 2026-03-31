# aws-ecs-platform

Production-style AWS ECS Fargate platform built with Terraform.

A public reference implementation for running containerised workloads on AWS using a fully modular Terraform layout, per-module remote state, and a GitOps-friendly CI/CD pipeline.

No live AWS account details, subscription IDs, or secrets are included.

## What This Repository Demonstrates

- Modular Terraform design for AWS
- ECS Fargate platform with ALB, WAF, Cognito, Secrets Manager, SNS
- Per-module, per-environment remote state stored in S3 with DynamoDB locking
- Cross-module state references via `terraform_remote_state`
- Multi-environment layout (`dev` / `stg`) with isolated state and environment-specific values
- CI/CD validation with `terraform fmt`, `terraform validate`, `tflint`, and `checkov`

## Architecture

```
Internet
   │
  WAF (AWS WAFv2)
   │
  ALB (Application Load Balancer)
   │
  ECS Fargate (private subnets)
   ├── ECR           — container image registry
   ├── Secrets Manager — DB passwords, API keys
   ├── Cognito       — user authentication (OAuth2 / OIDC)
   └── SNS           — email alerts + CloudWatch alarms
```

## Repository Layout

```
bootstrap/              — S3 bucket + DynamoDB table for remote state (run once)
modules/
  vpc/                  — VPC, subnets, IGW, NAT Gateway, route tables
  ecr/                  — ECR repository with lifecycle policy
  alb/                  — ALB, target group, listeners, security group
  waf/                  — WAFv2 WebACL with managed rule sets and rate limiting
  iam/                  — ECS execution role, task role, least-privilege policies
  secrets/              — Secrets Manager secret with initial placeholder values
  sns/                  — SNS topic with email subscriptions
  cognito/              — Cognito User Pool, App Client, hosted UI domain
  ecs/                  — ECS cluster, Fargate service, task definition, autoscaling, CloudWatch alarms
envs/
  dev/                  — development environment (one directory per module)
  stg/                  — staging environment (one directory per module)
.github/workflows/
  terraform.yml         — CI pipeline: fmt, validate, tflint, checkov
```

## Remote State Layout

Each module in each environment has its own isolated state file:

```
s3://tfstate-aws-ecs-platform/
  dev/vpc/terraform.tfstate
  dev/ecr/terraform.tfstate
  dev/alb/terraform.tfstate
  dev/waf/terraform.tfstate
  dev/iam/terraform.tfstate
  dev/secrets/terraform.tfstate
  dev/sns/terraform.tfstate
  dev/cognito/terraform.tfstate
  dev/ecs/terraform.tfstate
  stg/vpc/terraform.tfstate
  stg/...
```

Modules that depend on each other read outputs via `terraform_remote_state`. For example, `envs/dev/ecs` reads VPC subnet IDs, ALB target group ARN, ECR URL, IAM role ARNs, and SNS topic ARN from the respective state files.

## Modules

### `vpc`
VPC with public and private subnets across two availability zones, Internet Gateway, NAT Gateway, and route tables.

### `ecr`
Private ECR repository with image scanning on push and a lifecycle policy to retain the last N images.

### `alb`
Application Load Balancer in public subnets with a target group (IP mode for Fargate), HTTP listener, optional HTTPS listener with redirect, and a dedicated security group.

### `waf`
WAFv2 WebACL attached to the ALB with AWS managed rule sets (Common Rules, Known Bad Inputs) and a configurable IP-based rate limit rule.

### `iam`
ECS task execution role with least-privilege access to ECR and Secrets Manager. ECS task role with permissions to publish to SNS and read secrets at runtime.

### `secrets`
Secrets Manager secret for application credentials. Initial values are written once; subsequent rotations are ignored by Terraform (`lifecycle.ignore_changes`).

### `sns`
SNS topic with email subscriptions used for CloudWatch alarm notifications.

### `cognito`
Cognito User Pool with email-based sign-in, password policy, and a hosted UI domain. App Client configured for the Authorization Code flow with PKCE.

### `ecs`
ECS cluster with Container Insights enabled, Fargate task definition, ECS service with deployment circuit breaker and rollback, Application Autoscaling on CPU utilisation, and CloudWatch alarms for CPU and memory high.

## CI/CD

GitHub Actions validates all environments on every push and pull request.

| Step | Tool | Purpose |
|---|---|---|
| Format check | `terraform fmt -check` | Consistent HCL formatting |
| Init | `terraform init -backend=false` | Provider resolution without remote state |
| Validate | `terraform validate` | Syntax and internal consistency |
| Lint | `tflint` | Provider-specific errors, deprecated arguments, wrong types |
| Security scan | `checkov` | Misconfigurations — encryption, public access, IAM over-permissioning |

The pipeline does not require AWS credentials.

## How To Use

### 1. Bootstrap remote state (run once)

```bash
cd bootstrap
terraform init
terraform apply
```

### 2. Deploy a module

Apply modules in dependency order — `vpc` first, then the rest:

```bash
cd envs/dev/vpc
terraform init
terraform apply

cd ../ecr
terraform init
terraform apply

# continue for: secrets, sns, alb, waf, cognito, iam, ecs
```

### 3. Update `terraform.tfvars`

Each environment directory contains a `terraform.tfvars` with sensible defaults. Replace placeholder values (email addresses, callback URLs, certificate ARNs) before applying.

## Environment Differences

| Setting | dev | stg |
|---|---|---|
| VPC CIDR | `10.0.0.0/16` | `10.1.0.0/16` |
| Task CPU | 256 | 512 |
| Task memory | 512 MiB | 1024 MiB |
| Desired count | 1 | 2 |
| WAF rate limit | 2000 req/5min | 3000 req/5min |
| Log retention | 30 days | 60 days |

## Notes

- This is a reference implementation, not a production-ready landing zone.
- Add remote state for the bootstrap itself, private DNS, ACM certificates, and a deployment pipeline for container images as next steps.
- The `checkov` step runs with `soft_fail: true` to allow reviewing findings without blocking the pipeline during the portfolio phase.
