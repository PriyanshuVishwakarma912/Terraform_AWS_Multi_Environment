# Terraform AWS Multi-Environment Infrastructure

A production-ready Terraform configuration for managing AWS infrastructure across multiple environments (Development, Staging, and Production) using a modular and scalable approach.

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Directory Structure](#directory-structure)
- [Getting Started](#getting-started)
- [Configuration](#configuration)
- [Usage](#usage)
- [Environment Specifications](#environment-specifications)
- [Outputs](#outputs)
- [Best Practices](#best-practices)
- [Troubleshooting](#troubleshooting)

---

## Overview

This repository implements Infrastructure as Code (IaC) using Terraform to provision and manage AWS resources across three distinct environments: **Development**, **Staging**, and **Production**. The infrastructure uses Terraform workspaces to manage environment-specific configurations with a single codebase, enabling consistent deployments while allowing environment-specific customization.

### Key Capabilities
- **Multi-environment management** using Terraform workspaces
- **Modular architecture** for EC2, S3, and DynamoDB resources
- **Scalable resource provisioning** with count-based resource management
- **Environment-specific configurations** for cost optimization and performance

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                 Terraform AWS Multi-Environment                  │
└─────────────────────────────────────────────────────────────────┘
                              │
                 ┌────────────┼────────────┐
                 │            │            │
            ┌────▼────┐  ┌────▼────┐  ┌────▼────┐
            │   Dev   │  │ Staging  │  │   Prod  │
            │Workspace│  │Workspace │  │Workspace│
            └────┬────┘  └────┬────┘  └────┬────┘
                 │            │            │
    ┌────────────┼────────────┼────────────┤
    │            │            │            │
┌───▼────┐  ┌───▼────┐  ┌───▼────┐  ┌───▼────┐
│ EC2    │  │   S3   │  │DynamoDB│  │Security│
│ Module │  │ Module │  │ Module │  │ Group  │
└────────┘  └────────┘  └────────┘  └────────┘
    │            │            │            │
    └────────────┴────────────┴────────────┘
            │
    ┌───────▼────────┐
    │  AWS Regions   │
    │ ap-south-1 (IN)│
    └────────────────┘
```

### Resource Topology by Environment

| Environment | EC2 Instances | S3 Buckets | DynamoDB Tables | Purpose |
|-------------|---------------|------------|-----------------|---------|
| **Development** | 2 | 1 | 1 | Testing & Development |
| **Staging** | 3 | 1 | 1 | Pre-production validation |
| **Production** | 4 | 1 | 2 | Live workloads |

---

## Features

✅ **Multi-Environment Support** - Manage dev, staging, and production with a single codebase  
✅ **Modular Design** - Separate modules for EC2, S3, and DynamoDB for reusability  
✅ **Workspace-based Management** - Use Terraform workspaces for environment isolation  
✅ **Scalable Resources** - Dynamic resource count based on environment configuration  
✅ **Security Configuration** - VPC security groups with ingress/egress rules  
✅ **Cost Optimization** - Environment-specific resource sizing  
✅ **State Management** - Organized Terraform state per environment  
✅ **SSH Key Management** - EC2 key pair provisioning and management  

---

## Prerequisites

Before you begin, ensure you have the following installed and configured:

### Software Requirements
- **Terraform** >= 1.0 (recommended: 1.x latest)
- **AWS CLI** >= 2.0
- **Git** for version control

### AWS Requirements
- Active AWS account with appropriate IAM permissions
- AWS credentials configured locally
- EC2 key pair file (`demo-iac-key.pub`) for SSH access

### IAM Permissions
Ensure your AWS user/role has permissions for:
- EC2 (instances, security groups, key pairs)
- S3 (bucket creation and management)
- DynamoDB (table creation and management)
- VPC (security group management)

### Installation

```bash
# Install Terraform (macOS with Homebrew)
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Verify installation
terraform version

# Configure AWS credentials
aws configure
```

---

## Directory Structure

```
Terraform_AWS_Multi_Environment/
│
├── README.md                          # Project documentation
├── providers.tf                       # AWS provider configuration
├── variables.tf                       # Root-level variables
├── main.tf                            # Root module configuration
├── .gitignore                         # Git ignore rules
│
└── modules/                           # Reusable Terraform modules
    │
    ├── ec2/                           # EC2 module
    │   ├── main.tf                    # EC2 resources (instances, security groups)
    │   ├── variables.tf               # EC2 input variables
    │   └── outputs.tf                 # EC2 outputs
    │
    ├── s3/                            # S3 module
    │   ├── main.tf                    # S3 bucket configuration
    │   ├── variables.tf               # S3 input variables
    │   └── outputs.tf                 # S3 outputs
    │
    └── dynamoDB/                      # DynamoDB module
        ├── main.tf                    # DynamoDB table configuration
        ├── variables.tf               # DynamoDB input variables
        └── outputs.tf                 # DynamoDB outputs
```

---

## Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/PriyanshuVishwakarma912/Terraform_AWS_Multi_Environment.git
cd Terraform_AWS_Multi_Environment
```

### 2. Generate SSH Key Pair (if not already present)

```bash
# Generate key pair for EC2 access
ssh-keygen -t rsa -b 4096 -f demo-iac-key -N ""

# This creates:
# - demo-iac-key (private key - keep secure)
# - demo-iac-key.pub (public key - uploaded to AWS)
```

### 3. Initialize Terraform

```bash
# Initialize Terraform (downloads providers and modules)
terraform init
```

### 4. Create Workspaces

```bash
# Create development workspace
terraform workspace new dev

# Create staging workspace
terraform workspace new stg

# Create production workspace
terraform workspace new prd

# List all workspaces
terraform workspace list
```

### 5. Select Environment and Plan

```bash
# Switch to development environment
terraform workspace select dev

# Review infrastructure changes
terraform plan

# (Repeat for stg and prd environments)
```

### 6. Apply Configuration

```bash
# Apply infrastructure changes
terraform apply

# Confirm with 'yes' when prompted
```

---

## Configuration

### Environment-Specific Settings

Environment configurations are defined in `main.tf` using local variables:

```hcl
locals {
  env = {
    dev = {
      instance_count = 2
      bucket_count   = 1
      dynamo_count   = 1
    }
    stg = {
      instance_count = 3
      bucket_count   = 1
      dynamo_count   = 1
    }
    prd = {
      instance_count = 4
      bucket_count   = 1
      dynamo_count   = 2
    }
  }
  current = lookup(local.env, terraform.workspace, local.env["dev"])
}
```

### AWS Region Configuration

The default region is set to **ap-south-1 (Mumbai, India)**. To change:

**In `providers.tf`:**
```hcl
provider "aws" {
  region = "us-east-1"  # Change to desired region
}
```

### EC2 Instance Configuration

Customize instance parameters in `modules/ec2/variables.tf`:

| Variable | Default | Description |
|----------|---------|-------------|
| `ec2_instance_name` | terra-iac-server | Instance name prefix |
| `ec2_instance_type` | t3.micro | Instance type |
| `ec2_ami_id` | ami-05d2d839d4f73aafb | Amazon Machine Image ID |
| `ec2_volume_size` | 8 | EBS volume size (GB) |

### S3 Bucket Configuration

S3 buckets are created with environment-aware naming:
```
Format: my-test-bucket-{environment}
Example: my-test-bucket-dev, my-test-bucket-stg, my-test-bucket-prd
```

### DynamoDB Configuration

DynamoDB tables are created with:
- **Billing Mode**: PAY_PER_REQUEST (pay per request)
- **Hash Key**: LockID (string type)
- **Naming Pattern**: `{table_name}-{index}`
- **Environment Tag**: Automatically tagged with environment name

---

## Usage

### Working with Environments

#### Switch Between Environments

```bash
# List available workspaces
terraform workspace list

# Switch to an environment
terraform workspace select dev
terraform workspace select stg
terraform workspace select prd
```

#### View Infrastructure Plan

```bash
# Show what will be created/modified
terraform workspace select dev
terraform plan

# Save plan to a file (recommended for production)
terraform plan -out=dev.tfplan
terraform apply dev.tfplan
```

#### Destroy Infrastructure

```bash
# Destroy resources in current environment
terraform workspace select dev
terraform destroy

# Confirm with 'yes' when prompted
# WARNING: This will delete all resources!
```

### Viewing Outputs

```bash
# After applying, view resource details
terraform output

# View specific output
terraform output -json
```

### State Management

```bash
# Show current state
terraform show

# List resources in state
terraform state list

# Show specific resource
terraform state show aws_instance.my_instance
```

---

## Environment Specifications

### Development (dev)
- **2 EC2 instances** (t3.micro) for testing
- **1 S3 bucket** for development data
- **1 DynamoDB table** for testing state management
- **Use Case**: Development and testing environment

### Staging (stg)
- **3 EC2 instances** (t3.micro) for pre-production validation
- **1 S3 bucket** for staging data
- **1 DynamoDB table** for state management
- **Use Case**: Pre-production testing and validation

### Production (prd)
- **4 EC2 instances** (t3.micro) for live workloads
- **1 S3 bucket** for production data
- **2 DynamoDB tables** for enhanced redundancy
- **Use Case**: Production environment with higher availability

---

## Outputs

After running `terraform apply`, the following information will be available:

```bash
# EC2 Instance IDs
Instance IDs: i-1234567890abcdef0

# S3 Bucket Names
Bucket Name: my-test-bucket-dev

# DynamoDB Table Names
Table Name: practice_remote_table-1
```

Access outputs using:
```bash
terraform output <output_name>
```

---

## Best Practices

### 1. **State Management**
- Store Terraform state remotely (S3 + DynamoDB) for team collaboration
- Enable state locking to prevent concurrent modifications
- Use `.gitignore` to exclude sensitive state files

### 2. **Security**
- Never commit SSH private keys or `.tfvars` files
- Use AWS IAM roles for EC2 instances in production
- Implement network ACLs and security group rules carefully
- Rotate SSH keys regularly

### 3. **Environment Isolation**
- Maintain separate AWS accounts for prod/staging/dev (recommended)
- Use workspace-specific variable files for additional customization
- Document environment-specific configurations

### 4. **Code Quality**
- Use `terraform fmt` to format code consistently
- Run `terraform validate` before committing
- Use `terraform plan` to review changes before applying

### 5. **Monitoring and Logging**
- Enable CloudWatch logs for EC2 instances
- Monitor S3 bucket access with CloudTrail
- Set up DynamoDB autoscaling for production

---

## Troubleshooting

### Common Issues and Solutions

#### 1. **SSH Key Not Found Error**
```
Error: Error reading SSH key: open demo-iac-key.pub: no such file or directory
```
**Solution:**
```bash
# Generate the key pair
ssh-keygen -t rsa -b 4096 -f demo-iac-key -N ""
```

#### 2. **AWS Credentials Not Configured**
```
Error: error configuring Terraform AWS Provider: no valid credential sources for Terraform AWS Provider found
```
**Solution:**
```bash
# Configure AWS credentials
aws configure

# Or set environment variables
export AWS_ACCESS_KEY_ID="your_access_key"
export AWS_SECRET_ACCESS_KEY="your_secret_key"
```

#### 3. **Region-Specific AMI ID Invalid**
```
Error: Error launching instance with AMI ID ami-05d2d839d4f73aafb
```
**Solution:**
- Update the `ec2_ami_id` in `modules/ec2/variables.tf` with a valid AMI ID for your region
```bash
# Find AMI ID for your region
aws ec2 describe-images --owners amazon --filters "Name=name,Values=amzn2-ami-hvm-*" --region ap-south-1
```

#### 4. **Workspace Not Found**
```
Error: No workspace found with given name
```
**Solution:**
```bash
# Create the workspace first
terraform workspace new workspace_name

# Then select it
terraform workspace select workspace_name
```

#### 5. **State Locked Error**
```
Error: resource is locked
```
**Solution:**
```bash
# Force unlock (use with caution)
terraform force-unlock <LOCK_ID>
```

### Useful Debug Commands

```bash
# Enable debug logging
export TF_LOG=DEBUG
terraform apply

# Validate configuration
terraform validate

# Format code
terraform fmt -recursive

# Check for security issues (if using tfsec)
tfsec .
```

---

## Contributing

1. Create a feature branch: `git checkout -b feature/your-feature`
2. Make your changes and test with `terraform plan`
3. Format code: `terraform fmt -recursive`
4. Validate: `terraform validate`
5. Commit with descriptive messages: `git commit -m "Add: description"`
6. Push to branch: `git push origin feature/your-feature`
7. Open a Pull Request

---

## License

This project is open source and available under the [MIT License](LICENSE).

---

## Support & Contact

For issues, questions, or suggestions:
- 📝 Open an issue on [GitHub](https://github.com/PriyanshuVishwakarma912/Terraform_AWS_Multi_Environment/issues)
- 📧 Contact: PriyanshuVishwakarma912

---

## Changelog

### v1.0.0 (Current)
- ✅ Initial release with multi-environment support
- ✅ EC2, S3, and DynamoDB modules
- ✅ Workspace-based environment management
- ✅ Security group configuration
- ✅ SSH key pair management

---

**Last Updated**: May 27, 2026  
**Terraform Version**: >= 1.0  
**AWS Provider Version**: ~> 6.0
