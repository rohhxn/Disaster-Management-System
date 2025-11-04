# Quick Start Guide - AWS EC2 Deployment

This is a quick reference guide for deploying the Disaster Management System on AWS EC2.

## 🚀 Quick Setup (5 steps)

### 1. Generate SSH Key
```bash
ssh-keygen -t rsa -b 4096 -f ~/.ssh/dams-key -N ""
chmod 400 ~/.ssh/dams-key
```

### 2. Configure AWS Credentials
```bash
aws configure
# Enter your AWS Access Key ID, Secret Access Key, Region, and Output format
```

### 3. Deploy Infrastructure
```bash
cd terraform-demo
terraform init
terraform apply -auto-approve
```

Save the output:
```bash
terraform output > deployment-info.txt
```

### 4. Connect to EC2
Wait 3-5 minutes for initialization, then:
```bash
ssh -i ~/.ssh/dams-key ec2-user@$(terraform output -raw elastic_ip)
```

### 5. Deploy Application
On the EC2 instance, run:
```bash
# Download and run the deployment script
curl -o deploy.sh https://raw.githubusercontent.com/rohhxn/Disaster-Management-System/main/deploy-to-ec2.sh
chmod +x deploy.sh
./deploy.sh
```

Or manually:
```bash
cd /opt/dams
git clone https://github.com/rohhxn/Disaster-Management-System.git .

# Create .env file
cat > .env << 'EOF'
NODE_ENV=production
DB_USER=dams-admin
DB_PASS=$(openssl rand -base64 32)
DB_NAME=dams
DB_HOST=dams-postgres
DB_PORT=5432
DB_DIALECT=postgres
JWT_TOKEN=$(openssl rand -base64 64)
CLIENT_HOST=0.0.0.0
CLIENT_PORT=5050
SERVER_HOST=0.0.0.0
SERVER_PORT=5000
EOF

# Start services
docker-compose up -d
```

## 🌐 Access Your Application

Get the URLs:
```bash
# From your local machine in terraform-demo directory
terraform output client_url
terraform output server_url
```

Or visit:
- Client: `http://<ELASTIC_IP>:5050`
- API: `http://<ELASTIC_IP>:5000`

## 📋 Common Commands

### On Local Machine
```bash
# SSH into server
ssh -i ~/.ssh/dams-key ec2-user@$(terraform output -raw elastic_ip)

# Destroy infrastructure
terraform destroy -auto-approve
```

### On EC2 Instance
```bash
cd /opt/dams

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Update application
git pull && docker-compose pull && docker-compose up -d

# Stop services
docker-compose down

# Import database
docker exec -i dams-postgres psql -U dams-admin -d dams < dams.sql
```

## 🔧 Troubleshooting

### Can't connect to EC2?
- Wait 3-5 minutes after terraform apply
- Check security group allows SSH from your IP
- Verify key permissions: `chmod 400 ~/.ssh/dams-key`

### Application not accessible?
```bash
# On EC2, check containers
docker-compose ps

# Check logs
docker-compose logs

# Restart services
docker-compose restart
```

### Need to change passwords?
```bash
cd /opt/dams

# Edit .env file
vim .env

# Restart services
docker-compose down
docker-compose up -d
```

## 📖 Full Documentation

For detailed information, see [DEPLOYMENT.md](./DEPLOYMENT.md)

## 💰 Cost Estimation

- **t2.micro**: Free tier eligible, ~$8-10/month after
- **t2.medium**: ~$33/month
- **Elastic IP**: Free when attached to running instance
- **Storage (30GB)**: ~$3/month

**Total estimated cost**: $35-40/month for production setup

## 🛡️ Security Checklist

- [ ] Changed default DB_PASS and JWT_TOKEN
- [ ] Restricted SSH access to your IP only
- [ ] Set up HTTPS (Let's Encrypt)
- [ ] Enabled AWS CloudWatch monitoring
- [ ] Regular backups scheduled
- [ ] Updated security group rules

## 📞 Support

- **Full Docs**: [DEPLOYMENT.md](./DEPLOYMENT.md)
- **Repository**: https://github.com/rohhxn/Disaster-Management-System
- **Issues**: https://github.com/rohhxn/Disaster-Management-System/issues
