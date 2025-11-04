# DAMS Deployment Manager for Windows
# PowerShell script to manage AWS EC2 deployment

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('deploy', 'destroy', 'ssh', 'status', 'logs', 'update', 'help')]
    [string]$Action = 'help'
)

$ErrorActionPreference = "Stop"

# Colors
function Write-Success { param($Message) Write-Host $Message -ForegroundColor Green }
function Write-Info { param($Message) Write-Host $Message -ForegroundColor Cyan }
function Write-Warning { param($Message) Write-Host $Message -ForegroundColor Yellow }
function Write-Error { param($Message) Write-Host $Message -ForegroundColor Red }

# Configuration
$TerraformDir = Join-Path $PSScriptRoot "terraform-demo"
$SSHKeyPath = Join-Path $env:USERPROFILE ".ssh\dams-key"

function Show-Help {
    Write-Host @"
====================================
DAMS Deployment Manager
====================================

Usage: .\deploy-manager.ps1 -Action <action>

Actions:
  deploy    - Deploy infrastructure to AWS
  destroy   - Destroy AWS infrastructure
  ssh       - Connect to EC2 instance via SSH
  status    - Show deployment status
  logs      - View application logs (requires SSH)
  update    - Update application on EC2
  help      - Show this help message

Examples:
  .\deploy-manager.ps1 -Action deploy
  .\deploy-manager.ps1 -Action ssh
  .\deploy-manager.ps1 -Action status

Prerequisites:
  - AWS CLI configured
  - Terraform installed
  - SSH client available

"@
}

function Test-Prerequisites {
    Write-Info "Checking prerequisites..."
    
    # Check AWS CLI
    try {
        $null = aws --version
        Write-Success "✓ AWS CLI is installed"
    } catch {
        Write-Error "✗ AWS CLI is not installed. Install from: https://aws.amazon.com/cli/"
        exit 1
    }
    
    # Check Terraform
    try {
        $null = terraform version
        Write-Success "✓ Terraform is installed"
    } catch {
        Write-Error "✗ Terraform is not installed. Install from: https://www.terraform.io/downloads"
        exit 1
    }
    
    # Check SSH
    try {
        $null = ssh -V 2>&1
        Write-Success "✓ SSH client is available"
    } catch {
        Write-Error "✗ SSH client is not available. Enable OpenSSH in Windows Settings."
        exit 1
    }
    
    Write-Success "`nAll prerequisites met!`n"
}

function Initialize-SSHKey {
    if (-not (Test-Path $SSHKeyPath)) {
        Write-Info "Generating SSH key pair..."
        $sshDir = Split-Path $SSHKeyPath
        if (-not (Test-Path $sshDir)) {
            New-Item -ItemType Directory -Path $sshDir -Force | Out-Null
        }
        ssh-keygen -t rsa -b 4096 -f $SSHKeyPath -N '""'
        Write-Success "SSH key generated: $SSHKeyPath"
    } else {
        Write-Success "SSH key already exists: $SSHKeyPath"
    }
}

function Deploy-Infrastructure {
    Write-Info "`n======================================"
    Write-Info "Deploying DAMS to AWS EC2"
    Write-Info "======================================`n"
    
    Test-Prerequisites
    Initialize-SSHKey
    
    # Change to terraform directory
    Push-Location $TerraformDir
    
    try {
        # Initialize Terraform
        Write-Info "Initializing Terraform..."
        terraform init
        
        # Create tfvars if not exists
        if (-not (Test-Path "terraform.tfvars")) {
            Write-Warning "terraform.tfvars not found. Creating from example..."
            Copy-Item "terraform.tfvars.example" "terraform.tfvars"
            Write-Warning "Please edit terraform.tfvars with your values before continuing."
            Write-Host "`nPress Enter to continue after editing terraform.tfvars..."
            Read-Host
        }
        
        # Plan
        Write-Info "`nCreating deployment plan..."
        terraform plan -out=tfplan
        
        # Confirm
        Write-Warning "`nReview the plan above."
        $confirm = Read-Host "Do you want to proceed with deployment? (yes/no)"
        if ($confirm -ne "yes") {
            Write-Warning "Deployment cancelled."
            return
        }
        
        # Apply
        Write-Info "`nApplying configuration..."
        terraform apply tfplan
        
        # Save outputs
        Write-Info "`nSaving deployment information..."
        terraform output | Out-File "deployment-info.txt"
        
        # Display outputs
        Write-Success "`n======================================"
        Write-Success "Deployment completed successfully!"
        Write-Success "======================================`n"
        
        $elasticIP = terraform output -raw elastic_ip
        $clientURL = terraform output -raw client_url
        $serverURL = terraform output -raw server_url
        
        Write-Host "Elastic IP: $elasticIP"
        Write-Host "Client URL: $clientURL"
        Write-Host "Server URL: $serverURL"
        Write-Host "`nSSH Command: ssh -i $SSHKeyPath ec2-user@$elasticIP"
        
        Write-Warning "`nWait 3-5 minutes for instance initialization to complete."
        Write-Info "Then run: .\deploy-manager.ps1 -Action ssh"
        Write-Info "On the EC2 instance, run the deployment script."
        
    } finally {
        Pop-Location
    }
}

function Destroy-Infrastructure {
    Write-Warning "`n======================================"
    Write-Warning "Destroying AWS Infrastructure"
    Write-Warning "======================================`n"
    
    $confirm = Read-Host "Are you sure you want to destroy all resources? This cannot be undone! (yes/no)"
    if ($confirm -ne "yes") {
        Write-Warning "Destruction cancelled."
        return
    }
    
    Push-Location $TerraformDir
    
    try {
        Write-Info "Destroying infrastructure..."
        terraform destroy
        Write-Success "`nInfrastructure destroyed successfully!"
    } finally {
        Pop-Location
    }
}

function Connect-SSH {
    Push-Location $TerraformDir
    
    try {
        $elasticIP = terraform output -raw elastic_ip 2>$null
        if (-not $elasticIP) {
            Write-Error "No infrastructure found. Deploy first with: .\deploy-manager.ps1 -Action deploy"
            return
        }
        
        Write-Info "Connecting to EC2 instance at $elasticIP..."
        Write-Info "Run this command on the EC2 instance to deploy the application:"
        Write-Host ""
        Write-Host "cd /opt/dams" -ForegroundColor Yellow
        Write-Host "git clone https://github.com/rohhxn/Disaster-Management-System.git ." -ForegroundColor Yellow
        Write-Host "# Create .env file with secure passwords" -ForegroundColor Yellow
        Write-Host "docker-compose up -d" -ForegroundColor Yellow
        Write-Host ""
        
        ssh -i $SSHKeyPath "ec2-user@$elasticIP"
    } finally {
        Pop-Location
    }
}

function Show-Status {
    Push-Location $TerraformDir
    
    try {
        Write-Info "`n======================================"
        Write-Info "Deployment Status"
        Write-Info "======================================`n"
        
        $elasticIP = terraform output -raw elastic_ip 2>$null
        if (-not $elasticIP) {
            Write-Warning "No infrastructure deployed."
            return
        }
        
        Write-Success "Infrastructure is deployed!`n"
        
        Write-Host "Instance Details:"
        Write-Host "  Elastic IP: $(terraform output -raw elastic_ip)"
        Write-Host "  Instance ID: $(terraform output -raw instance_id)"
        Write-Host "  Public DNS: $(terraform output -raw instance_public_dns)"
        
        Write-Host "`nApplication URLs:"
        Write-Host "  Client: $(terraform output -raw client_url)"
        Write-Host "  Server: $(terraform output -raw server_url)"
        
        Write-Host "`nSSH Command:"
        Write-Host "  $(terraform output -raw ssh_command)" -ForegroundColor Cyan
        
    } finally {
        Pop-Location
    }
}

function Show-Logs {
    Push-Location $TerraformDir
    
    try {
        $elasticIP = terraform output -raw elastic_ip 2>$null
        if (-not $elasticIP) {
            Write-Error "No infrastructure found."
            return
        }
        
        Write-Info "Fetching logs from EC2 instance..."
        ssh -i $SSHKeyPath "ec2-user@$elasticIP" "cd /opt/dams && docker-compose logs --tail=100"
    } finally {
        Pop-Location
    }
}

function Update-Application {
    Push-Location $TerraformDir
    
    try {
        $elasticIP = terraform output -raw elastic_ip 2>$null
        if (-not $elasticIP) {
            Write-Error "No infrastructure found."
            return
        }
        
        Write-Info "Updating application on EC2 instance..."
        ssh -i $SSHKeyPath "ec2-user@$elasticIP" @"
cd /opt/dams
git pull
docker-compose pull
docker-compose up -d
"@
        Write-Success "Application updated successfully!"
    } finally {
        Pop-Location
    }
}

# Main execution
switch ($Action) {
    'deploy' { Deploy-Infrastructure }
    'destroy' { Destroy-Infrastructure }
    'ssh' { Connect-SSH }
    'status' { Show-Status }
    'logs' { Show-Logs }
    'update' { Update-Application }
    'help' { Show-Help }
    default { Show-Help }
}
