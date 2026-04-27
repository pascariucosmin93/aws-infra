# aws-ecs-platform

AWS-native Terraform platform for running a web application on ECS Fargate with secure edge, multi-AZ networking, managed data services, and per-environment state isolation.

This repository is portfolio-focused, but structured to reflect production engineering standards.

## Core Design

- Compute: ECS Fargate behind ALB
- Edge security: AWS WAFv2 attached to ALB
- Network: public, private-app, private-data subnet tiers
- Data: Amazon RDS (Multi-AZ) + ElastiCache Redis
- Secrets: AWS Secrets Manager
- Observability: CloudWatch logs + alarms, SNS notifications
- State: S3 remote state + DynamoDB lock table, isolated per env/module

## High-Level Architecture

```text
Internet
  -> ALB (public subnets)
  -> WAFv2 (managed rules + rate limiting)
  -> ECS Fargate services (private-app subnets)
  -> RDS PostgreSQL (private-data subnets, Multi-AZ)
  -> ElastiCache Redis (private-data subnets, Multi-AZ)
```

## Repository Layout

```text
bootstrap/                      # state bucket + lock table
modules/
  vpc/                          # VPC, subnet tiers, NAT, route tables
  alb/                          # ALB, listeners, target group, SG
  waf/                          # WAF web ACL + managed rules + optional allowlist
  ecs/                          # ECS cluster/service/task, autoscaling, alarms
  rds/                          # Multi-AZ RDS + subnet group + SG
  redis/                        # Redis replication group + subnet group + SG
  iam/                          # ECS execution/task roles
  secrets/                      # Secrets Manager secret
  ecr/                          # ECR repo + lifecycle policy
  sns/                          # SNS alert topic
  cognito/                      # auth layer
envs/
  dev/
    vpc/ alb/ waf/ ecr/ iam/ secrets/ sns/ cognito/ ecs/ rds/ redis/
  stg/
    vpc/ alb/ waf/ ecr/ iam/ secrets/ sns/ cognito/ ecs/ rds/ redis/
```

## Important Engineering Decisions

- `stg` state is isolated from `dev` (backend keys + `terraform_remote_state` references).
- VPC supports `nat_gateway_per_az` for higher availability in higher environments.
- Data tier is isolated in dedicated `private_data` subnets.
- ALB hardened with strict desync mitigation and invalid header drop.
- WAF includes:
  - AWS managed common rules
  - AWS IP reputation rules
  - known-bad-input rules
  - rate limiting
  - optional allowlist CIDRs
- ECS autoscaling uses both CPU and memory target tracking.

## Deployment Order (Per Environment)

Apply in this order:

1. `vpc`
2. `ecr`
3. `secrets`
4. `sns`
5. `alb`
6. `waf`
7. `iam`
8. `ecs`
9. `rds`
10. `redis`
11. `cognito` (if needed by your app path)

## Example Workflow

```bash
cd envs/dev/vpc
terraform init
terraform apply

cd ../alb
terraform init
terraform apply
```

Repeat by module order.

## Security Posture

- IAM role-based access for workloads (no static credentials in app runtime)
- App-to-data access constrained via security groups
- RDS not publicly accessible
- Encryption enabled for RDS and Redis
- Secrets stored in Secrets Manager

## Portfolio Notes

This repo intentionally prioritizes clarity and modularity over enterprise complexity (for example, no GitOps controller, no service mesh, no multi-account landing zone), while still demonstrating production-relevant patterns.
