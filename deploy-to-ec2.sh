#!/bin/bash

# Disaster Management System - Quick Deploy Script for EC2
# This script should be run on the EC2 instance after SSH connection

set -e

echo "======================================"
echo "DAMS Deployment Script"
echo "======================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if running as ec2-user
if [ "$(whoami)" != "ec2-user" ]; then
    echo -e "${RED}This script should be run as ec2-user${NC}"
    exit 1
fi

# Set application directory
APP_DIR="/opt/dams"

echo -e "${YELLOW}Step 1: Checking Docker installation...${NC}"
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Docker is not installed. Installing...${NC}"
    sudo dnf install -y docker
    sudo systemctl start docker
    sudo systemctl enable docker
    sudo usermod -aG docker ec2-user
    echo -e "${GREEN}Docker installed successfully${NC}"
else
    echo -e "${GREEN}Docker is already installed${NC}"
fi

echo ""
echo -e "${YELLOW}Step 2: Checking Docker Compose installation...${NC}"
if ! command -v docker-compose &> /dev/null; then
    echo -e "${RED}Docker Compose is not installed. Installing...${NC}"
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo -e "${GREEN}Docker Compose installed successfully${NC}"
else
    echo -e "${GREEN}Docker Compose is already installed${NC}"
fi

echo ""
echo -e "${YELLOW}Step 3: Checking Git installation...${NC}"
if ! command -v git &> /dev/null; then
    echo -e "${RED}Git is not installed. Installing...${NC}"
    sudo dnf install -y git
    echo -e "${GREEN}Git installed successfully${NC}"
else
    echo -e "${GREEN}Git is already installed${NC}"
fi

echo ""
echo -e "${YELLOW}Step 4: Creating application directory...${NC}"
if [ ! -d "$APP_DIR" ]; then
    sudo mkdir -p $APP_DIR
    sudo chown ec2-user:ec2-user $APP_DIR
    echo -e "${GREEN}Directory created: $APP_DIR${NC}"
else
    echo -e "${GREEN}Directory already exists: $APP_DIR${NC}"
fi

cd $APP_DIR

echo ""
echo -e "${YELLOW}Step 5: Cloning repository...${NC}"
if [ ! -d ".git" ]; then
    read -p "Enter GitHub repository URL (default: https://github.com/rohhxn/Disaster-Management-System.git): " REPO_URL
    REPO_URL=${REPO_URL:-https://github.com/rohhxn/Disaster-Management-System.git}
    git clone $REPO_URL .
    echo -e "${GREEN}Repository cloned successfully${NC}"
else
    echo -e "${GREEN}Repository already exists. Pulling latest changes...${NC}"
    git pull
fi

echo ""
echo -e "${YELLOW}Step 6: Setting up environment file...${NC}"
if [ ! -f ".env" ]; then
    echo -e "${YELLOW}Creating .env file...${NC}"
    
    # Generate random passwords
    DB_PASS=$(openssl rand -base64 32)
    JWT_TOKEN=$(openssl rand -base64 64)
    
    cat > .env << EOF
NODE_ENV=production

DB_USER=dams-admin
DB_PASS=$DB_PASS
DB_NAME=dams
DB_HOST=dams-postgres
DB_PORT=5432
DB_DIALECT=postgres

JWT_TOKEN=$JWT_TOKEN

CLIENT_HOST=0.0.0.0
CLIENT_PORT=5050
SERVER_HOST=0.0.0.0
SERVER_PORT=5000
EOF
    
    echo -e "${GREEN}.env file created with auto-generated passwords${NC}"
    echo -e "${YELLOW}Note: Passwords are stored in $APP_DIR/.env${NC}"
else
    echo -e "${GREEN}.env file already exists${NC}"
    read -p "Do you want to regenerate it? (y/N): " REGENERATE
    if [[ $REGENERATE =~ ^[Yy]$ ]]; then
        DB_PASS=$(openssl rand -base64 32)
        JWT_TOKEN=$(openssl rand -base64 64)
        
        cat > .env << EOF
NODE_ENV=production

DB_USER=dams-admin
DB_PASS=$DB_PASS
DB_NAME=dams
DB_HOST=dams-postgres
DB_PORT=5432
DB_DIALECT=postgres

JWT_TOKEN=$JWT_TOKEN

CLIENT_HOST=0.0.0.0
CLIENT_PORT=5050
SERVER_HOST=0.0.0.0
SERVER_PORT=5000
EOF
        echo -e "${GREEN}.env file regenerated${NC}"
    fi
fi

echo ""
echo -e "${YELLOW}Step 7: Starting Docker containers...${NC}"
docker-compose down 2>/dev/null || true
docker-compose pull
docker-compose up -d

echo ""
echo -e "${YELLOW}Step 8: Waiting for containers to be healthy...${NC}"
sleep 10

# Check container status
if docker-compose ps | grep -q "Up"; then
    echo -e "${GREEN}Containers are running!${NC}"
    docker-compose ps
else
    echo -e "${RED}Some containers failed to start. Check logs:${NC}"
    docker-compose logs
    exit 1
fi

echo ""
echo "======================================"
echo -e "${GREEN}Deployment completed successfully!${NC}"
echo "======================================"
echo ""
echo "Application URLs:"
echo "  Client: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):5050"
echo "  Server: http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4):5000"
echo ""
echo "Useful commands:"
echo "  View logs: docker-compose logs -f"
echo "  Restart: docker-compose restart"
echo "  Stop: docker-compose down"
echo "  Update: git pull && docker-compose pull && docker-compose up -d"
echo ""
echo -e "${YELLOW}Note: If you need to import the database schema, run:${NC}"
echo "  docker exec -i dams-postgres psql -U dams-admin -d dams < dams.sql"
echo ""
