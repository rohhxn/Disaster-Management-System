provider "aws" {
  region = "us-east-1"  # Change as needed
}

resource "aws_instance" "my_instance" {
  ami           = "ami-071226ecf16aa7d96" 
  instance_type = "t2.micro"

  tags = {
    Name = "Terraform-Instance"
  }
}
