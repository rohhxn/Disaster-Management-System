# 🚨 Disaster Management System (DAMS)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Docker](https://img.shields.io/badge/Docker-Ready-blue.svg)](https://www.docker.com/)
[![Node.js](https://img.shields.io/badge/Node.js-18.x-green.svg)](https://nodejs.org/)
[![Python](https://img.shields.io/badge/Python-3.x-blue.svg)](https://www.python.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-16-blue.svg)](https://www.postgresql.org/)

A comprehensive web-based disaster management system designed to coordinate relief efforts, connect donors with recipients, and manage emergency resources efficiently during crisis situations.

---

## 📋 Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Technology Stack](#technology-stack)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Deployment](#deployment)
- [Project Structure](#project-structure)
- [API Documentation](#api-documentation)
- [Testing](#testing)
- [Contributing](#contributing)
- [License](#license)
- [Support](#support)

---

## 🎯 Overview

The Disaster Management System (DAMS) is a full-stack web application that facilitates coordination between disaster relief organizations, donors, and affected communities. The platform enables real-time tracking of relief efforts, resource management, and efficient distribution of aid during emergency situations.

### Key Objectives

- 🤝 **Connect Donors & Recipients**: Bridge the gap between those who can help and those who need help
- 📊 **Resource Management**: Track and manage relief supplies, volunteers, and financial aid
- 🗺️ **Real-time Coordination**: Enable efficient coordination between multiple relief organizations
- 📱 **Accessibility**: Provide easy-to-use interfaces for all stakeholders
- 🔒 **Security**: Ensure data privacy and secure transactions

---

## ✨ Features

### For Administrators
- ✅ Dashboard with real-time analytics
- ✅ User and role management
- ✅ Event and disaster tracking
- ✅ Resource allocation monitoring
- ✅ Report generation and analytics
- ✅ System configuration and settings

### For Donors
- ✅ Register and manage donor profile
- ✅ Browse active disaster events
- ✅ Make pledges (monetary, supplies, volunteer time)
- ✅ Track donation history
- ✅ View impact and utilization reports
- ✅ Receive acknowledgments and updates

### For Recipients
- ✅ Submit relief requests
- ✅ Specify urgent needs and priorities
- ✅ Track request status
- ✅ Receive aid distribution updates
- ✅ Provide feedback on assistance received

### System Features
- 🔐 JWT-based authentication and authorization
- 📧 Email notifications (configurable)
- 📊 Real-time dashboard and analytics
- 🗄️ Robust database with PostgreSQL
- 🐳 Containerized deployment with Docker
- 🔄 RESTful API architecture
- 📱 Responsive web interface
- 🔍 Search and filter capabilities
- 📈 Progress tracking and reporting

---

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────────┐
│                     Client Layer                        │
│            (Flask + Jinja2 Templates)                   │
│                   Port: 5050                            │
└─────────────────┬───────────────────────────────────────┘
                  │
                  │ HTTP/REST API
                  │
┌─────────────────▼───────────────────────────────────────┐
│                    Server Layer                         │
│              (Node.js + Express)                        │
│                   Port: 5000                            │
│                                                         │
│  ┌──────────────────────────────────────────────────┐  │
│  │  Routes: Auth, Admin, Donor, Recipient          │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                   │
│  ┌──────────────────▼───────────────────────────────┐  │
│  │  Middleware: Authentication, Validation         │  │
│  └──────────────────┬───────────────────────────────┘  │
│                     │                                   │
│  ┌──────────────────▼───────────────────────────────┐  │
│  │  Models: User, Event, Pledge, Request           │  │
│  └──────────────────┬───────────────────────────────┘  │
└────────────────────┬────────────────────────────────────┘
                     │
                     │ Sequelize ORM
                     │
┌────────────────────▼────────────────────────────────────┐
│               Database Layer                            │
│            PostgreSQL 16                                │
│                Port: 5432                               │
│                                                         │
│  Tables: Users, Events, Pledges, Requests, etc.       │
└─────────────────────────────────────────────────────────┘
```

### Technology Flow

1. **Frontend Request** → User interacts with Flask web interface
2. **API Call** → Flask client makes REST API calls to Node.js server
3. **Authentication** → JWT token validation via middleware
4. **Business Logic** → Express routes process requests
5. **Data Access** → Sequelize ORM queries PostgreSQL database
6. **Response** → JSON data returned through API
7. **Rendering** → Flask renders templates with data

---

## 🛠️ Technology Stack

### Frontend
- **Flask** (Python 3.x) - Web framework
- **Jinja2** - Template engine
- **Bootstrap 4** - UI framework
- **jQuery** - JavaScript library
- **SB Admin 2** - Dashboard theme

### Backend
- **Node.js** (18.x) - Runtime environment
- **Express.js** - Web framework
- **Sequelize** - ORM for database operations
- **JWT** - Authentication tokens
- **bcrypt** - Password hashing

### Database
- **PostgreSQL 16** - Primary database
- **Sequelize CLI** - Database migrations

### DevOps & Infrastructure
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Terraform** - Infrastructure as Code (AWS)
- **Ansible** - Configuration management
- **GitHub Actions** - CI/CD pipeline

### Testing
- **Jest** - Backend testing framework
- **Pytest** - Frontend testing framework
- **Supertest** - API testing
- **Coverage.py** - Code coverage

### Cloud & Deployment
- **AWS EC2** - Compute instances
- **Amazon Linux 2023** - Operating system
- **GitHub Container Registry** - Docker image storage

---

## 📋 Prerequisites

### Local Development

- **Node.js** 16.x or higher
- **Python** 3.8 or higher
- **PostgreSQL** 14 or higher
- **Docker** & **Docker Compose** (optional but recommended)
- **Git**

### Cloud Deployment

- **AWS Account** with EC2 access
- **Terraform** 1.0 or higher
- **AWS CLI** configured
- **SSH Key Pair** for EC2 access

---

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)

```bash
# Clone the repository
git clone https://github.com/rohhxn/Disaster-Management-System.git
cd Disaster-Management-System

# Create environment file
cp .env.production.example .env
# Edit .env with your configuration

# Start all services
docker-compose -f docker-compose-prod.yml up -d

# Check status
docker-compose -f docker-compose-prod.yml ps

# View logs
docker-compose -f docker-compose-prod.yml logs -f
```

Access the application:
- **Client**: http://localhost:5050
- **Server API**: http://localhost:5000

### Option 2: Local Development

#### Backend Setup

```bash
# Navigate to server directory
cd server

# Install dependencies
npm install

# Configure environment
cp .env.example .env
# Edit .env with database credentials

# Start development server
npm run server
```

#### Frontend Setup

```bash
# Navigate to client directory
cd client

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env with server URL

# Start development server
python app/app.py
```

#### Database Setup

```bash
# Create PostgreSQL database
createdb dams

# Import schema
psql -U postgres -d dams < dams.sql

# Or use Sequelize migrations
cd server
npx sequelize-cli db:migrate
```

---

## 🚢 Deployment

### AWS EC2 Deployment

We provide comprehensive deployment documentation:

1. **[Quick Start Guide](./QUICKSTART.md)** - Deploy in 5 steps
2. **[Full Deployment Guide](./DEPLOYMENT.md)** - Detailed instructions
3. **[Deployment Checklist](./DEPLOYMENT-CHECKLIST.md)** - Pre-deployment verification
4. **[Visual Guide](./VISUAL-GUIDE.md)** - Diagrams and flowcharts
5. **[Current Instance Info](./CURRENT-INSTANCE-INFO.md)** - Your specific setup

#### Quick Deploy to AWS

```bash
# Step 1: Generate SSH key
ssh-keygen -t rsa -b 4096 -f ~/.ssh/dams-key -N ""

# Step 2: Configure Terraform
cd terraform-demo
cp terraform.tfvars.example terraform.tfvars
# Edit terraform.tfvars

# Step 3: Deploy infrastructure
terraform init
terraform apply

# Step 4: Connect to EC2 (wait 3-5 minutes first)
ssh -i ~/.ssh/dams-key ec2-user@$(terraform output -raw elastic_ip)

# Step 5: Deploy application
cd /opt/dams
git clone https://github.com/rohhxn/Disaster-Management-System.git .
# Create .env file
docker-compose -f docker-compose-prod.yml up -d
```

For troubleshooting, see [FIX-DOCKER-COMPOSE.md](./FIX-DOCKER-COMPOSE.md)

### Windows PowerShell Deployment

```powershell
# Use the deployment manager
.\deploy-manager.ps1 -Action deploy
.\deploy-manager.ps1 -Action status
.\deploy-manager.ps1 -Action ssh
```

---

## 📁 Project Structure

```
Disaster-Management-System/
│
├── client/                          # Flask frontend application
│   ├── app/
│   │   ├── app.py                  # Main Flask application
│   │   ├── static/                 # CSS, JS, images
│   │   │   ├── css/
│   │   │   ├── js/
│   │   │   ├── img/
│   │   │   └── vendor/
│   │   ├── templates/              # Jinja2 templates
│   │   │   ├── home.html
│   │   │   ├── login.html
│   │   │   ├── register.html
│   │   │   ├── admin/              # Admin templates
│   │   │   ├── donor/              # Donor templates
│   │   │   └── recipient/          # Recipient templates
│   │   └── tests/                  # Frontend tests
│   ├── requirements.txt            # Python dependencies
│   └── Dockerfile                  # Client Docker image
│
├── server/                         # Node.js backend application
│   ├── routes/                     # API route handlers
│   │   ├── admin.js
│   │   ├── donor.js
│   │   ├── recipient.js
│   │   ├── login.js
│   │   └── register.js
│   ├── models/                     # Sequelize models
│   │   ├── user.js
│   │   ├── event.js
│   │   ├── pledge.js
│   │   └── request.js
│   ├── middleware/                 # Express middleware
│   │   └── auth.js
│   ├── database/                   # Database configuration
│   │   └── index.js
│   ├── tests/                      # Backend tests
│   ├── package.json                # Node dependencies
│   ├── index.js                    # Server entry point
│   └── Dockerfile                  # Server Docker image
│
├── terraform-demo/                 # Infrastructure as Code
│   ├── main.tf                     # Main Terraform config
│   ├── variables.tf                # Variable definitions
│   ├── outputs.tf                  # Output values
│   ├── terraform.tfvars.example    # Example variables
│   └── README.md                   # Terraform documentation
│
├── ansible/                        # Configuration management
│   ├── deploy-project.yml          # Deployment playbook
│   ├── deploy-project-ci.yml       # CI/CD playbook
│   ├── roles/                      # Ansible roles
│   └── hosts/                      # Inventory files
│
├── .github/                        # GitHub Actions workflows
│   └── workflows/
│       └── ci-cd.yml
│
├── docker-compose.yml              # Development compose file
├── docker-compose-prod.yml         # Production compose file
├── dams.sql                        # Database schema
├── .env.production.example         # Example environment variables
├── .gitignore                      # Git ignore rules
│
├── DEPLOYMENT.md                   # Full deployment guide
├── QUICKSTART.md                   # Quick start guide
├── DEPLOYMENT-CHECKLIST.md         # Deployment checklist
├── VISUAL-GUIDE.md                 # Visual deployment guide
├── FIX-DOCKER-COMPOSE.md          # Troubleshooting guide
│
└── README.md                       # This file
```

---

## 📚 API Documentation

### Authentication

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

### Endpoints

#### Authentication
- `POST /login` - User login
- `POST /register` - User registration
- `POST /logout` - User logout

#### Admin Routes
- `GET /admin/dashboard` - Admin dashboard data
- `GET /admin/users` - List all users
- `PUT /admin/users/:id` - Update user
- `DELETE /admin/users/:id` - Delete user
- `GET /admin/events` - List all events
- `POST /admin/events` - Create event
- `PUT /admin/events/:id` - Update event
- `DELETE /admin/events/:id` - Delete event

#### Donor Routes
- `GET /donor/dashboard` - Donor dashboard
- `GET /donor/events` - Available events
- `POST /donor/pledge` - Create pledge
- `GET /donor/pledges` - View donor's pledges
- `PUT /donor/pledge/:id` - Update pledge

#### Recipient Routes
- `GET /recipient/dashboard` - Recipient dashboard
- `POST /recipient/request` - Submit relief request
- `GET /recipient/requests` - View recipient's requests
- `PUT /recipient/request/:id` - Update request status

### Response Format

```json
{
  "success": true,
  "message": "Operation successful",
  "data": { ... }
}
```

Error responses:

```json
{
  "success": false,
  "error": "Error message",
  "code": 400
}
```

---

## 🧪 Testing

### Backend Tests

```bash
cd server

# Run all tests
npm test

# Run tests with coverage
npm run test-cicd

# Run specific test file
npm test -- tests/admin.test.js
```

### Frontend Tests

```bash
cd client

# Run all tests
pytest

# Run with coverage
pytest --cov=app --cov-report=html

# Run specific test
pytest tests/test_app.py
```

### Test Coverage

Current coverage:
- **Backend**: ~85% (routes, models, middleware)
- **Frontend**: ~75% (app logic, templates)

---

## 🔧 Configuration

### Environment Variables

#### Backend (.env in server/)
```properties
NODE_ENV=production
DB_USER=dams-admin
DB_PASS=your_secure_password
DB_NAME=dams
DB_HOST=dams-postgres
DB_PORT=5432
DB_DIALECT=postgres
JWT_TOKEN=your_secure_jwt_secret
PORT=5000
```

#### Frontend (.env in client/)
```properties
CLIENT_HOST=0.0.0.0
CLIENT_PORT=5050
SERVER_HOST=dams-server
SERVER_PORT=5000
```

### Database Configuration

Edit `server/database/index.js` for custom database settings.

---

## 🔒 Security

- ✅ JWT-based authentication
- ✅ Password hashing with bcrypt
- ✅ SQL injection prevention via Sequelize ORM
- ✅ XSS protection with template escaping
- ✅ CORS configuration
- ✅ Environment variable protection
- ✅ HTTPS recommended for production
- ✅ Rate limiting (recommended to implement)
- ✅ Input validation and sanitization

### Security Best Practices

1. **Change default credentials** in production
2. **Use strong passwords** (minimum 12 characters)
3. **Generate secure JWT secrets** (64+ characters)
4. **Enable HTTPS** with SSL certificates
5. **Restrict database access** to internal network only
6. **Regular security updates** for dependencies
7. **Implement rate limiting** for API endpoints
8. **Regular backups** of database

---

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**
   ```bash
   git checkout -b feature/amazing-feature
   ```
3. **Commit your changes**
   ```bash
   git commit -m "Add amazing feature"
   ```
4. **Push to the branch**
   ```bash
   git push origin feature/amazing-feature
   ```
5. **Open a Pull Request**

### Development Guidelines

- Follow existing code style and conventions
- Write tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting PR
- Keep commits atomic and well-described

### Code Style

- **JavaScript**: ES6+, 2-space indentation
- **Python**: PEP 8, 4-space indentation
- **Naming**: camelCase (JS), snake_case (Python)
- **Comments**: JSDoc for functions, inline for complex logic

---

## 📊 Performance

### Optimization Tips

1. **Database Indexing**: Ensure proper indexes on frequently queried columns
2. **Connection Pooling**: Configure Sequelize pool settings
3. **Caching**: Implement Redis for session and query caching
4. **Load Balancing**: Use Nginx for multiple instances
5. **CDN**: Serve static assets via CDN
6. **Compression**: Enable gzip compression
7. **Monitoring**: Set up CloudWatch or similar monitoring

---

## 🐛 Troubleshooting

### Common Issues

**Issue**: Containers won't start
```bash
# Check logs
docker-compose -f docker-compose-prod.yml logs

# Restart services
docker-compose -f docker-compose-prod.yml restart
```

**Issue**: Database connection failed
```bash
# Verify database is running
docker-compose -f docker-compose-prod.yml ps

# Check database logs
docker logs dams-postgres

# Verify credentials in .env
```

**Issue**: Port already in use
```bash
# Find process using port
lsof -i :5050
lsof -i :5000

# Kill process or change port in .env
```

For more troubleshooting, see [FIX-DOCKER-COMPOSE.md](./FIX-DOCKER-COMPOSE.md)

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

```
MIT License

Copyright (c) 2025 Disaster Management System Contributors

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction...
```

---

## 👥 Authors & Contributors

- **Asad Mahmood** - Backend Development
- **Stefan Radovic** - Backend Development
- **Dennis Kurtz** - Backend Development
- **[Your Name]** - Infrastructure & Deployment

See [CONTRIBUTORS.md](CONTRIBUTORS.md) for a full list of contributors.

---

## 🙏 Acknowledgments

- **SB Admin 2** - Dashboard template
- **Bootstrap** - UI framework
- **PostgreSQL** - Database system
- **Docker** - Containerization platform
- **AWS** - Cloud infrastructure
- **Open Source Community** - Various libraries and tools

---

## 📞 Support

### Documentation
- [Full Deployment Guide](./DEPLOYMENT.md)
- [Quick Start](./QUICKSTART.md)
- [Deployment Checklist](./DEPLOYMENT-CHECKLIST.md)
- [Visual Guide](./VISUAL-GUIDE.md)
- [Terraform README](./terraform-demo/README.md)

### Get Help
- **Issues**: [GitHub Issues](https://github.com/rohhxn/Disaster-Management-System/issues)
- **Discussions**: [GitHub Discussions](https://github.com/rohhxn/Disaster-Management-System/discussions)
- **Email**: support@dams.example.com

### Useful Links
- **Live Demo**: http://your-demo-url.com (if available)
- **Documentation**: https://docs.dams.example.com (if available)
- **Status Page**: https://status.dams.example.com (if available)

---

## 🗺️ Roadmap

### Version 2.0 (Planned)
- [ ] Mobile application (React Native)
- [ ] Real-time notifications (WebSockets)
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Map integration for disaster zones
- [ ] SMS integration for alerts
- [ ] Volunteer management module
- [ ] Inventory tracking system
- [ ] Payment gateway integration
- [ ] Machine learning for demand prediction

### Version 1.5 (In Progress)
- [x] Docker containerization
- [x] AWS deployment automation
- [x] CI/CD pipeline
- [ ] Performance optimization
- [ ] Enhanced security features
- [ ] API rate limiting

---

## 📈 Statistics

- **Lines of Code**: ~15,000+
- **Test Coverage**: 80%+
- **Docker Images**: 3 (Client, Server, Database)
- **API Endpoints**: 30+
- **Database Tables**: 10+
- **Dependencies**: 50+ packages

---

## 🌟 Star History

If you find this project helpful, please consider giving it a ⭐ on GitHub!

[![Star History Chart](https://api.star-history.com/svg?repos=rohhxn/Disaster-Management-System&type=Date)](https://star-history.com/#rohhxn/Disaster-Management-System&Date)

---

## 📸 Screenshots

### Dashboard
![Dashboard](docs/screenshots/dashboard.png)

### Donor Portal
![Donor Portal](docs/screenshots/donor.png)

### Recipient Portal
![Recipient Portal](docs/screenshots/recipient.png)

*(Add actual screenshots to `docs/screenshots/` directory)*

---

<div align="center">

**Made with ❤️ for disaster relief efforts**

[Report Bug](https://github.com/rohhxn/Disaster-Management-System/issues) · 
[Request Feature](https://github.com/rohhxn/Disaster-Management-System/issues) · 
[Documentation](./DEPLOYMENT.md)

</div>
