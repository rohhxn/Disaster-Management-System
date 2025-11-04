output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.dams_instance.id
}

output "instance_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.dams_instance.public_ip
}

output "elastic_ip" {
  description = "Elastic IP address"
  value       = aws_eip.dams_eip.public_ip
}

output "instance_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.dams_instance.public_dns
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.dams_sg.id
}

output "ssh_command" {
  description = "SSH command to connect to the instance"
  value       = "ssh -i ~/.ssh/dams-key ec2-user@${aws_eip.dams_eip.public_ip}"
}

output "client_url" {
  description = "URL to access the client application"
  value       = "http://${aws_eip.dams_eip.public_ip}:5050"
}

output "server_url" {
  description = "URL to access the server API"
  value       = "http://${aws_eip.dams_eip.public_ip}:5000"
}
