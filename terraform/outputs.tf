
output "ec2_public_ips" {
  description = "Public IP addresses of EC2 instances"
  value       = { for key, instance in aws_instance.web : key => instance.public_ip }
}

output "ec2_public_dns" {
  description = "Public DNS names of EC2 instances"
  value       = { for key, instance in aws_instance.web : key => instance.public_dns }
}

output "portfolio_urls" {
  description = "Portfolio website URLs"
  value       = { for key, instance in aws_instance.web : key => "http://${instance.public_ip}" }
}
    