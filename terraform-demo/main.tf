provider "aws" {
  region = var.region
}

# Security Group for the EC2 instance
resource "aws_security_group" "dams_sg" {
  name        = "dams-security-group"
  description = "Security group for Disaster Management System"

  # SSH access
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH access"
  }

  # HTTP access
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP access"
  }

  # HTTPS access
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS access"
  }

  # Client port
  ingress {
    from_port   = 5050
    to_port     = 5050
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Client application port"
  }

  # Server port
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Server application port"
  }

  # PostgreSQL port (only if you want external access)
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "PostgreSQL database port"
  }

  # All outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = {
    Name = "DAMS-SecurityGroup"
  }
}

# Key pair for SSH access
resource "aws_key_pair" "dams_key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)

  tags = {
    Name = "DAMS-KeyPair"
  }
}

# EC2 Instance for DAMS
resource "aws_instance" "dams_instance" {
  # Amazon Linux 3 AMI (us-east-1) - Update based on your region
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.dams_key.key_name

  vpc_security_group_ids = [aws_security_group.dams_sg.id]

  # Increase root volume size for Docker images and data
  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = "gp3"
    delete_on_termination = true
    encrypted             = true

    tags = {
      Name = "DAMS-RootVolume"
    }
  }

  # User data script to install Docker and Docker Compose
  user_data = <<-EOF
              #!/bin/bash
              set -e
              
              # Update system
              sudo dnf update -y
              
              # Install Docker
              sudo dnf install -y docker
              
              # Start and enable Docker
              sudo systemctl start docker
              sudo systemctl enable docker
              
              # Add ec2-user to docker group
              sudo usermod -aG docker ec2-user
              
              # Install Docker Compose
              sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              sudo chmod +x /usr/local/bin/docker-compose
              
              # Create symbolic link
              sudo ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
              
              # Install git
              sudo dnf install -y git
              
              # Install utilities
              sudo dnf install -y curl wget vim htop
              
              # Create application directory
              sudo mkdir -p /opt/dams
              sudo chown ec2-user:ec2-user /opt/dams
              
              # Reboot to apply group changes
              echo "Docker and Docker Compose installed successfully"
              EOF

  tags = {
    Name        = "DAMS-Instance"
    Environment = var.environment
    Project     = "Disaster-Management-System"
  }
}

# Elastic IP for static public IP
resource "aws_eip" "dams_eip" {
  instance = aws_instance.dams_instance.id
  domain   = "vpc"

  tags = {
    Name = "DAMS-ElasticIP"
  }
}
