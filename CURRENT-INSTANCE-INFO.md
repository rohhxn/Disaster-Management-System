# Your Current AWS Configuration

## 🌍 Active Instance Details

**Instance Information:**
- **Instance ID**: `i-0ea490f89a1d8bfa0`
- **Instance Type**: `t3.small` (2 vCPUs, 2 GiB RAM)
- **Region**: `ap-south-1` (Mumbai, India)
- **Availability Zone**: `ap-south-1a`
- **Public IP**: `3.110.94.100`
- **Private IP**: `172.31.32.42`
- **Status**: ✅ Running (3/3 checks passed)
- **Public DNS**: `ec2-3-110-94-100.ap-south-1.compute.amazonaws.com`

## 📊 Instance Specifications

**t3.small Features:**
- **vCPUs**: 2
- **Memory**: 2 GiB RAM
- **Network Performance**: Up to 5 Gigabit
- **Burst**: Burstable performance
- **Cost**: ~$15-20/month (Mumbai pricing)

**Why t3.small is good:**
- ✅ Better CPU credits than t2 instances
- ✅ Baseline performance suitable for Docker containers
- ✅ More cost-effective than t2.medium
- ✅ Good for moderate traffic applications

## 🔗 Access URLs

Based on your public IP `3.110.94.100`:

```
Client Application:  http://3.110.94.100:5050
Server API:          http://3.110.94.100:5000
PostgreSQL (if exposed): http://3.110.94.100:5432

SSH Access:          ssh -i ~/.ssh/your-key.pem ec2-user@3.110.94.100
```

## 📝 Updated Terraform Configuration

Your `variables.tf` now matches your active instance:

```hcl
region        = "ap-south-1"    # Mumbai
instance_type = "t3.small"      # 2 vCPU, 2 GB RAM
ami_id        = "ami-0f58b397bc5c1f2e8"  # Amazon Linux 2023 for Mumbai
```

## 🚀 Next Steps to Deploy Your Application

### Option 1: Quick SSH Deploy

1. **Connect to your instance:**
   ```bash
   ssh -i ~/.ssh/your-key.pem ec2-user@3.110.94.100
   ```

2. **Install Docker (if not already):**
   ```bash
   sudo dnf update -y
   sudo dnf install -y docker git
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -aG docker ec2-user
   
   # Install Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
   
   # Log out and back in for group changes
   exit
   ```

3. **Deploy your application:**
   ```bash
   ssh -i ~/.ssh/your-key.pem ec2-user@3.110.94.100
   
   cd /opt
   sudo mkdir -p dams
   sudo chown ec2-user:ec2-user dams
   cd dams
   
   git clone https://github.com/rohhxn/Disaster-Management-System.git .
   
   # Create .env file
   cat > .env << 'EOF'
   NODE_ENV=production
   DB_USER=dams-admin
   DB_PASS=YourSecurePasswordHere
   DB_NAME=dams
   DB_HOST=dams-postgres
   DB_PORT=5432
   DB_DIALECT=postgres
   JWT_TOKEN=YourSecureJWTTokenHere
   CLIENT_HOST=0.0.0.0
   CLIENT_PORT=5050
   SERVER_HOST=0.0.0.0
   SERVER_PORT=5000
   EOF
   
   # Start services
   docker-compose up -d
   
   # Check status
   docker-compose ps
   ```

### Option 2: Use Deployment Script

```bash
# On your local machine
scp -i ~/.ssh/your-key.pem deploy-to-ec2.sh ec2-user@3.110.94.100:/home/ec2-user/

# SSH into instance
ssh -i ~/.ssh/your-key.pem ec2-user@3.110.94.100

# Run script
chmod +x deploy-to-ec2.sh
./deploy-to-ec2.sh
```

## 🔒 Security Checklist

For your Mumbai instance:

1. **Update Security Group Rules:**
   - [ ] Restrict SSH (port 22) to your IP only
   - [ ] Keep ports 5050, 5000 open for application
   - [ ] Remove public access to port 5432 (PostgreSQL) if not needed

2. **Configure Application:**
   - [ ] Set strong database password
   - [ ] Generate secure JWT token
   - [ ] Configure environment variables

3. **Enable Monitoring:**
   - [ ] Set up CloudWatch alarms
   - [ ] Monitor CPU and memory usage
   - [ ] Track application logs

## 📈 Monitoring Commands

```bash
# SSH into instance
ssh -i ~/.ssh/your-key.pem ec2-user@3.110.94.100

# Check Docker containers
docker-compose ps
docker-compose logs -f

# Check system resources
htop
df -h
free -h

# Check application ports
sudo netstat -tlnp | grep -E '5050|5000|5432'
```

## 💰 Cost Estimation (Mumbai Region)

- **t3.small instance**: ~₹1,200-1,500/month (~$15-18)
- **EBS Storage (30GB)**: ~₹180/month (~$2.50)
- **Data Transfer**: ~₹80-400/month (~$1-5)
- **Elastic IP (if detached)**: ~₹300/month (~$3.60)

**Total**: ~₹1,500-2,400/month (~$18-30)

## 📞 Support

If you need help:
1. Check [DEPLOYMENT.md](./DEPLOYMENT.md) for detailed instructions
2. See [QUICKSTART.md](./QUICKSTART.md) for fast deployment
3. Review [VISUAL-GUIDE.md](./VISUAL-GUIDE.md) for visual walkthrough

---

**Instance Status**: ✅ Running and Healthy
**Last Updated**: November 5, 2025
