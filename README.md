# Terraform Infrastructure - CloudScan Demo

This repository contains AWS infrastructure defined in Terraform, monitored by the **CloudScan CI/CD pipeline** for security misconfiguration detection.

## Architecture

| File | Description |
|------|-------------|
| `vpc.tf` | VPC, public/private subnets, route tables, internet gateway |
| `ec2.tf` | EC2 instance configuration |
| `sg.tf` | Security group rules (SSH, HTTP) |
| `backend.tf` | S3 backend with DynamoDB state locking |
| `version.tf` | Provider configuration (AWS, us-east-1) |
| `output.tf` | Output definitions |

## CI/CD Pipeline

The `.github/workflows/cloudscan.yml` pipeline automatically triggers when any `.tf` file is modified on a push or pull request to `main`.

### Pipeline Steps

1. **Detect Changes** — Identifies which `.tf` files were modified
2. **Package Terraform** — Zips all `.tf` files for analysis
3. **Build Graph** — Constructs infrastructure dependency graph *(placeholder)*
4. **RGCN Classification** — Runs ML model for risk classification *(placeholder)*
5. **LLM Remediation** — Generates fix suggestions *(placeholder)*
6. **Report Results** — Posts summary and fails build if high-risk issues found

### Demo Scenario

1. Create a branch and modify `sg.tf` to open SSH to `0.0.0.0/0`
2. Open a Pull Request to `main`
3. The pipeline detects the misconfiguration and fails the build
4. LLM suggests restricting the CIDR block to a specific IP

## Local Scan

```bash
chmod +x scripts/scan_terraform.sh
./scripts/scan_terraform.sh
```
