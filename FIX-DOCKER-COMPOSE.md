# Quick Fix for Docker Compose Build Issue

## Problem
The default `docker-compose.yml` tries to build the client image locally, but requires a newer version of Docker Buildx.

## Solution
Use the production docker-compose file that uses pre-built images from GitHub Container Registry.

---

## Run These Commands on Your EC2 Instance

```bash
# Navigate to your application directory
cd /opt/dams

# Stop any running containers
docker-compose down

# Use the production docker-compose file
# Option 1: Use docker-compose-prod.yml (already in repo)
docker-compose -f docker-compose-prod.yml up -d

# OR Option 2: Download the production version
wget https://raw.githubusercontent.com/rohhxn/Disaster-Management-System/main/docker-compose-prod.yml -O docker-compose-prod.yml
docker-compose -f docker-compose-prod.yml up -d

# Check status
docker-compose -f docker-compose-prod.yml ps

# View logs
docker-compose -f docker-compose-prod.yml logs -f
```

---

## Alternative: Update buildx (if you want to build locally)

```bash
# Install Docker Buildx
sudo dnf install -y docker-buildx-plugin

# Or update Docker to latest version
sudo dnf update -y docker docker-compose-plugin
sudo systemctl restart docker

# Then try again
docker-compose up -d
```

---

## Quick One-Liner Solution

```bash
cd /opt/dams && docker-compose -f docker-compose-prod.yml down && docker-compose -f docker-compose-prod.yml pull && docker-compose -f docker-compose-prod.yml up -d && docker-compose -f docker-compose-prod.yml ps
```

---

## Verify Deployment

After running the commands above:

```bash
# Check all containers are running
docker-compose -f docker-compose-prod.yml ps

# Check logs for any errors
docker-compose -f docker-compose-prod.yml logs

# Test the endpoints
curl http://localhost:5000  # Server API
curl http://localhost:5050  # Client App
```

---

## Access Your Application

Once containers are running:
- **Client App**: http://3.110.94.100:5050
- **Server API**: http://3.110.94.100:5000

---

## Troubleshooting

### If containers still don't start:

```bash
# Check Docker service
sudo systemctl status docker

# Check .env file exists
cat .env

# Try starting containers one by one
docker-compose -f docker-compose-prod.yml up -d dams-postgres
docker-compose -f docker-compose-prod.yml up -d dams-server
docker-compose -f docker-compose-prod.yml up -d dams-client

# Check specific container logs
docker logs dams-postgres
docker logs dams-server
docker logs dams-client
```

### If images fail to pull:

```bash
# Try pulling manually
docker pull postgres:latest
docker pull ghcr.io/parvathyullas25/dams/server:main
docker pull ghcr.io/parvathyullas25/dams/client:main

# Then start services
docker-compose -f docker-compose-prod.yml up -d
```

---

## Make Production Compose Default (Optional)

```bash
# Backup original
mv docker-compose.yml docker-compose.dev.yml

# Use production as default
cp docker-compose-prod.yml docker-compose.yml

# Now you can use without -f flag
docker-compose up -d
docker-compose ps
docker-compose logs -f
```

---

## Summary

The issue is resolved by using `docker-compose-prod.yml` which uses pre-built images instead of trying to build locally. This avoids the buildx requirement.

**Quick command to get it working:**
```bash
cd /opt/dams
docker-compose -f docker-compose-prod.yml up -d
```
