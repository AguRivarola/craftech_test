output "instance_ip" {
  description = "EC2 IP"
  value       = aws_instance.devops_ec2.public_ip
}

output "instance_id" {
  description = "EC2 id"
  value       = aws_instance.devops_ec2.id
}
