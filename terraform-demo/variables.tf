variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"  # Mumbai region (matching your current setup)
}

variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t3.small" # t3.small is good for Docker containers (better than t2.medium)
}

variable "ami_id" {
  description = "Amazon Linux 3 AMI ID (varies by region)"
  type        = string
  # Amazon Linux 2023 (AL2023) AMI for ap-south-1 (Mumbai)
  # Update this for your specific region
  default = "ami-0f58b397bc5c1f2e8"
}

variable "key_name" {
  description = "Name of the SSH key pair"
  type        = string
  default     = "dams-key"
}

variable "public_key_path" {
  description = "Path to the public SSH key"
  type        = string
  default     = "~/.ssh/dams-key.pub"
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  type        = number
  default     = 30
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}
