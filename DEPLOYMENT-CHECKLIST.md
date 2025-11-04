# Pre-Deployment Checklist for AWS EC2

Use this checklist to ensure you're ready to deploy the Disaster Management System.

## ✅ AWS Account Setup

- [ ] AWS account created and verified
- [ ] IAM user created with appropriate permissions
- [ ] AWS CLI installed on local machine
- [ ] AWS credentials configured (`aws configure`)
- [ ] Confirmed AWS region for deployment

## ✅ Local Tools Installation

- [ ] Terraform installed (v1.0+)
  - Download: https://www.terraform.io/downloads
  - Verify: `terraform version`

- [ ] AWS CLI installed
  - Download: https://aws.amazon.com/cli/
  - Verify: `aws --version`

- [ ] Git installed
  - Download: https://git-scm.com/downloads
  - Verify: `git --version`

- [ ] SSH client available
  - Windows: OpenSSH (built-in or installable)
  - Verify: `ssh -V`

## ✅ SSH Key Setup

- [ ] SSH key pair generated
  ```bash
  ssh-keygen -t rsa -b 4096 -f ~/.ssh/dams-key -N ""
  ```

- [ ] Correct permissions set
  ```bash
  chmod 400 ~/.ssh/dams-key
  ```

- [ ] Public key location noted: `~/.ssh/dams-key.pub`

## ✅ Terraform Configuration

- [ ] Navigated to `terraform-demo` directory
- [ ] Created `terraform.tfvars` from example
  ```bash
  cp terraform.tfvars.example terraform.tfvars
  ```

- [ ] Updated `terraform.tfvars` with:
  - [ ] AWS region
  - [ ] Instance type (t2.medium recommended)
  - [ ] SSH key name
  - [ ] SSH public key path
  - [ ] Amazon Linux 2023 AMI ID for your region

- [ ] Verified AMI ID is correct for your region
  - Check: https://console.aws.amazon.com/ec2/home#AMICatalog
  - Search: "Amazon Linux 2023"

## ✅ Application Configuration

- [ ] Reviewed `docker-compose.yml`
- [ ] Prepared `.env` file with secure values:
  - [ ] Secure database password generated
  - [ ] Secure JWT token generated
  - [ ] Production environment variables set

## ✅ Cost & Billing

- [ ] AWS billing alerts configured
- [ ] Understood estimated costs (~$35-40/month)
- [ ] Free tier eligibility checked (if applicable)
- [ ] Budget set in AWS Billing Console

## ✅ Security Considerations

- [ ] Reviewed security group rules
- [ ] Planned to restrict SSH access to specific IPs
- [ ] Noted need to remove public PostgreSQL access
- [ ] SSL/TLS certificate plan (Let's Encrypt)
- [ ] Database backup strategy planned

## ✅ Pre-Deployment Testing

- [ ] Terraform syntax validated
  ```bash
  cd terraform-demo
  terraform init
  terraform validate
  terraform plan
  ```

- [ ] No errors in terraform plan output
- [ ] AWS credentials working
  ```bash
  aws sts get-caller-identity
  ```

## ✅ Deployment Process

- [ ] Backed up any existing data
- [ ] Noted current date/time for rollback reference
- [ ] Ready to run:
  ```bash
  terraform apply
  ```

## ✅ Post-Deployment

- [ ] Saved Terraform outputs
  ```bash
  terraform output > deployment-info.txt
  ```

- [ ] Elastic IP noted and documented
- [ ] Connected to EC2 instance via SSH
- [ ] Application deployed on EC2
- [ ] Docker containers running successfully
- [ ] Application accessible via browser
- [ ] Database initialized (if needed)

## ✅ Verification Tests

- [ ] Client URL accessible: http://<ELASTIC_IP>:5050
- [ ] Server API accessible: http://<ELASTIC_IP>:5000
- [ ] Can register new user
- [ ] Can login successfully
- [ ] All features working correctly

## ✅ Monitoring & Maintenance

- [ ] CloudWatch monitoring enabled
- [ ] Log rotation configured
- [ ] Backup schedule established
- [ ] Update procedure documented
- [ ] Rollback procedure documented

## ✅ Documentation

- [ ] Elastic IP documented
- [ ] SSH key location documented
- [ ] Database credentials stored securely
- [ ] Application URLs documented
- [ ] Emergency contacts noted

## 🚨 Troubleshooting Reference

If something goes wrong:

1. **Can't connect to EC2:**
   - Wait 3-5 minutes after deployment
   - Check security group rules
   - Verify SSH key permissions

2. **Application not starting:**
   - Check Docker logs: `docker-compose logs`
   - Verify .env file exists and is correct
   - Check disk space: `df -h`

3. **Terraform errors:**
   - Run `terraform init` again
   - Check AWS credentials
   - Verify AMI ID is correct for region

4. **Need to start over:**
   - Run `terraform destroy`
   - Delete local .terraform directory
   - Start deployment process again

## 📞 Support Resources

- **Full Documentation:** [DEPLOYMENT.md](./DEPLOYMENT.md)
- **Quick Start:** [QUICKSTART.md](./QUICKSTART.md)
- **GitHub Repository:** https://github.com/rohhxn/Disaster-Management-System
- **AWS Support:** https://console.aws.amazon.com/support/home
- **Terraform Docs:** https://www.terraform.io/docs

## 🎉 Ready to Deploy?

Once all items are checked:

### Windows Users:
```powershell
.\deploy-manager.ps1 -Action deploy
```

### Linux/Mac Users:
```bash
cd terraform-demo
terraform init
terraform apply
```

Good luck with your deployment! 🚀
