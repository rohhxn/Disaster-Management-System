# Terraform Configuration for DAMS on AWS EC2

This directory contains Terraform configuration to deploy the Disaster Management System on AWS EC2 with Amazon Linux 3 (Amazon Linux 2023).

## 📁 Files

- `main.tf` - Main infrastructure configuration
- `variables.tf` - Input variables definition
- `outputs.tf` - Output values after deployment
- `terraform.tfvars.example` - Example variables file
- `terraform.tfvars` - Your actual variables (git-ignored)

## 🏗️ Infrastructure Components

This Terraform configuration creates:

1. **EC2 Instance** (Amazon Linux 2023)
   - Configurable instance type (default: t2.medium)
   - User data script for Docker installation
   - Increased root volume (30GB by default)

2. **Security Group**
   - SSH (port 22)
   - HTTP (port 80)
   - HTTPS (port 443)
   - Client App (port 5050)
   - Server API (port 5000)
   - PostgreSQL (port 5432) - optional

3. **SSH Key Pair**
   - For secure access to EC2

4. **Elastic IP**
   - Static public IP address

## 🚀 Quick Start

### 1. Prerequisites

```bash
# Verify installations
terraform version
aws --version
```

### 2. Configure Variables

```bash
# Copy example file
cp terraform.tfvars.example terraform.tfvars

# Edit with your values
vim terraform.tfvars
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Review Plan

```bash
terraform plan
```

### 5. Deploy

```bash
terraform apply
```

### 6. Get Outputs

```bash
terraform output
terraform output elastic_ip
terraform output ssh_command
```

## 📝 Configuration Options

### Required Variables

None - all variables have defaults.

### Optional Variables

Edit `terraform.tfvars` to customize:

```hcl
region            = "us-east-1"
instance_type     = "t2.medium"
key_name          = "dams-key"
public_key_path   = "~/.ssh/dams-key.pub"
root_volume_size  = 30
environment       = "production"
ami_id            = "ami-0dfcb1ef8550277af"
```

### AMI IDs by Region

Amazon Linux 2023 AMI IDs (as of Nov 2025):

| Region | AMI ID |
|--------|--------|
| us-east-1 (N. Virginia) | ami-0dfcb1ef8550277af |
| us-east-2 (Ohio) | ami-0f30a9c3a48f3fa79 |
| us-west-1 (N. California) | ami-0cbd38f5a3ed1f87d |
| us-west-2 (Oregon) | ami-0c2d06d50ce30b442 |
| ap-south-1 (Mumbai) | ami-0f58b397bc5c1f2e8 |
| eu-west-1 (Ireland) | ami-0d71ea30463e0ff8d |

**Note:** AMI IDs change over time. Get the latest from:
```bash
aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=al2023-ami-2023*" \
  --query 'sort_by(Images, &CreationDate)[-1].[ImageId,Name]' \
  --output text
```

## 📊 Outputs

After successful deployment:

- `instance_id` - EC2 instance identifier
- `instance_public_ip` - Public IP (dynamic)
- `elastic_ip` - Elastic IP (static)
- `instance_public_dns` - Public DNS name
- `security_group_id` - Security group ID
- `ssh_command` - Ready-to-use SSH command
- `client_url` - Client application URL
- `server_url` - Server API URL

## 🔧 Management Commands

### View Current State

```bash
terraform show
```

### Update Infrastructure

```bash
# Modify terraform.tfvars or *.tf files
terraform plan
terraform apply
```

### Destroy Infrastructure

```bash
terraform destroy
```

### Refresh State

```bash
terraform refresh
```

### Format Code

```bash
terraform fmt
```

### Validate Configuration

```bash
terraform validate
```

## 🔐 Security Best Practices

1. **Restrict SSH Access**
   
   Edit `main.tf` security group:
   ```hcl
   cidr_blocks = ["YOUR_IP/32"]  # Instead of 0.0.0.0/0
   ```

2. **Remove Public PostgreSQL Access**
   
   Comment out or remove the PostgreSQL ingress rule if database doesn't need external access.

3. **Use Terraform State Backend**
   
   For team environments, configure remote state:
   ```hcl
   terraform {
     backend "s3" {
       bucket = "your-terraform-state-bucket"
       key    = "dams/terraform.tfstate"
       region = "us-east-1"
     }
   }
   ```

4. **Enable Encryption**
   
   Already enabled for EBS volumes. Consider adding:
   - KMS keys for encryption
   - Secrets Manager for sensitive data

## 💰 Cost Estimation

Monthly costs (approximate):

| Resource | Type | Cost |
|----------|------|------|
| EC2 Instance | t2.micro | ~$8.50 |
| EC2 Instance | t2.medium | ~$33.00 |
| EBS Storage | 30GB gp3 | ~$2.40 |
| Elastic IP | (attached) | $0 |
| Elastic IP | (unattached) | ~$3.60 |
| Data Transfer | Varies | ~$1-5 |

**Total:** $35-45/month for production (t2.medium)

## 🐛 Troubleshooting

### Authentication Error

```bash
# Check AWS credentials
aws sts get-caller-identity

# Reconfigure if needed
aws configure
```

### Invalid AMI ID

```bash
# Update AMI ID for your region
# Check AWS Console or use AWS CLI to find latest AMI
```

### State Lock Error

```bash
# Force unlock (use carefully!)
terraform force-unlock <LOCK_ID>
```

### Instance Connection Timeout

- Wait 3-5 minutes after creation
- Check security group rules
- Verify key file permissions: `chmod 400 ~/.ssh/dams-key`

## 📚 Additional Resources

- [Terraform AWS Provider Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [AWS EC2 Documentation](https://docs.aws.amazon.com/ec2/)
- [Amazon Linux 2023 User Guide](https://docs.aws.amazon.com/linux/al2023/)

## 🆘 Support

For deployment help, see:
- [Main Deployment Guide](../DEPLOYMENT.md)
- [Quick Start Guide](../QUICKSTART.md)
- [Deployment Checklist](../DEPLOYMENT-CHECKLIST.md)
