# Disaster Management System - AWS EC2 Deployment Guide

This guide will help you deploy the Disaster Management System on AWS EC2 with Amazon Linux 3 (Amazon Linux 2023).

## Prerequisites

1. **AWS Account** with appropriate permissions to create:
   - EC2 instances
   - Security Groups
   - Elastic IPs
   - Key Pairs

2. **Installed Tools**:
   - [Terraform](https://www.terraform.io/downloads) (v1.0+)
   - [AWS CLI](https://aws.amazon.com/cli/) configured with your credentials
   - SSH client
   - Git

3. **AWS Credentials** configured locally:
   ```bash
   aws configure
   ```

## Step 1: Generate SSH Key Pair

Generate an SSH key pair for connecting to your EC2 instance:

```bash
# Create .ssh directory if it doesn't exist
mkdir -p ~/.ssh

# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/dams-key -N ""

# Set correct permissions
chmod 400 ~/.ssh/dams-key
```

## Step 2: Configure Terraform Variables

1. Navigate to the terraform directory:
   ```bash
   cd terraform-demo
   ```

2. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

3. Edit `terraform.tfvars` with your specific values:
   ```bash
   # Open with your preferred editor
   vim terraform.tfvars
   ```

4. Update the AMI ID for your region if needed. Check [AWS AMI Catalog](https://console.aws.amazon.com/ec2/home#AMICatalog) for the latest Amazon Linux 2023 AMI.

## Step 3: Deploy Infrastructure with Terraform

1. Initialize Terraform:
   ```bash
   terraform init
   ```

2. Review the deployment plan:
   ```bash
   terraform plan
   ```

3. Apply the configuration:
   ```bash
   terraform apply
   ```
   
   Type `yes` when prompted to confirm.

4. Save the outputs (displayed after successful apply):
   ```bash
   terraform output > deployment-info.txt
   ```

## Step 4: Wait for Instance Initialization

The EC2 instance needs a few minutes to:
- Install Docker
- Install Docker Compose
- Set up the environment

Wait approximately 3-5 minutes after the instance is created before proceeding.

## Step 5: Connect to EC2 Instance

Use the SSH command from Terraform outputs:

```bash
ssh -i ~/.ssh/dams-key ec2-user@<ELASTIC_IP>
```

Or get it from Terraform:
```bash
terraform output ssh_command
```

## Step 6: Deploy the Application

Once connected to the EC2 instance:

1. **Clone the repository**:
   ```bash
   cd /opt/dams
   git clone https://github.com/rohhxn/Disaster-Management-System.git .
   ```

2. **Create environment file**:
   ```bash
   cat > .env << 'EOF'
   NODE_ENV=production
   
   DB_USER=dams-admin
   DB_PASS=your_secure_password_here
   DB_NAME=dams
   DB_HOST=dams-postgres
   DB_PORT=5432
   DB_DIALECT=postgres
   
   JWT_TOKEN=your_secure_jwt_token_here
   
   CLIENT_HOST=0.0.0.0
   CLIENT_PORT=5050
   SERVER_HOST=0.0.0.0
   SERVER_PORT=5000
   EOF
   ```

   **Important**: Change `DB_PASS` and `JWT_TOKEN` to secure values!

3. **Start the application**:
   ```bash
   docker-compose up -d
   ```

4. **Check the status**:
   ```bash
   docker-compose ps
   ```

5. **View logs** (if needed):
   ```bash
   docker-compose logs -f
   ```

## Step 7: Access the Application

Get the URLs from Terraform outputs or use:

- **Client Application**: `http://<ELASTIC_IP>:5050`
- **Server API**: `http://<ELASTIC_IP>:5000`

Replace `<ELASTIC_IP>` with the Elastic IP from your Terraform outputs.

## Step 8: Database Initialization

If you need to initialize the database with the SQL schema:

1. **Copy the SQL file to the server**:
   ```bash
   # From your local machine
   scp -i ~/.ssh/dams-key dams.sql ec2-user@<ELASTIC_IP>:/opt/dams/
   ```

2. **Import the SQL file** (on the EC2 instance):
   ```bash
   docker exec -i dams-postgres psql -U dams-admin -d dams < /opt/dams/dams.sql
   ```

## Maintenance Commands

### View Application Logs
```bash
cd /opt/dams
docker-compose logs -f
```

### Restart Services
```bash
cd /opt/dams
docker-compose restart
```

### Stop Services
```bash
cd /opt/dams
docker-compose down
```

### Update Application
```bash
cd /opt/dams
git pull
docker-compose pull
docker-compose up -d
```

### Check System Resources
```bash
htop
df -h
docker system df
```

### Backup Database
```bash
docker exec dams-postgres pg_dump -U dams-admin dams > backup_$(date +%Y%m%d_%H%M%S).sql
```

## Security Recommendations

1. **Update Security Group Rules**: 
   - Remove PostgreSQL port (5432) from public access if not needed
   - Restrict SSH access to your IP only

2. **Use HTTPS**: 
   - Set up SSL/TLS certificates (Let's Encrypt)
   - Configure a reverse proxy (Nginx/Caddy)

3. **Enable AWS Monitoring**:
   - Set up CloudWatch alarms
   - Enable detailed monitoring

4. **Regular Updates**:
   ```bash
   sudo dnf update -y
   ```

5. **Firewall Configuration** (optional, additional layer):
   ```bash
   sudo firewall-cmd --permanent --add-port=5050/tcp
   sudo firewall-cmd --permanent --add-port=5000/tcp
   sudo firewall-cmd --reload
   ```

## Troubleshooting

### Docker not found
```bash
# Check if Docker is installed
docker --version

# If not, install manually:
sudo dnf install -y docker
sudo systemctl start docker
sudo systemctl enable docker
```

### Permission denied for Docker
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and log back in, or run:
newgrp docker
```

### Application not accessible
```bash
# Check if containers are running
docker-compose ps

# Check security group rules in AWS Console
# Ensure ports 5050 and 5000 are open

# Check if application is listening
sudo netstat -tlnp | grep -E '5050|5000'
```

### Database connection issues
```bash
# Check if PostgreSQL is running
docker exec dams-postgres pg_isready -U dams-admin

# View database logs
docker-compose logs dams-postgres
```

## Destroying Infrastructure

When you want to tear down the infrastructure:

```bash
cd terraform-demo
terraform destroy
```

Type `yes` when prompted. This will delete:
- EC2 instance
- Security Group
- Elastic IP
- Key Pair

**Warning**: This will permanently delete all data on the instance!

## Cost Optimization

- **Use t2.micro** for development/testing (included in AWS Free Tier)
- **Use t2.medium or larger** for production
- **Stop the instance** when not in use (you'll still pay for EBS storage)
- **Use Elastic IP** only when needed (charged when not attached to running instance)

## Support

For issues or questions:
- Check the [GitHub repository](https://github.com/rohhxn/Disaster-Management-System)
- Review application logs
- Check AWS CloudWatch logs

## Next Steps

1. Set up domain name and DNS
2. Configure SSL/TLS certificates
3. Set up automated backups
4. Implement CI/CD pipeline
5. Set up monitoring and alerting
6. Configure auto-scaling (optional)
