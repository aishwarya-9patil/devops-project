output "jenkins_url" {
  description = "Access Jenkins using this URL"
  value       = "http://${aws_instance.devops_server.public_ip}:8080"
}

output "sonarqube_url" {
  description = "Access SonarQube using this URL"
  value       = "http://${aws_instance.devops_server.public_ip}:9000"
}

output "argocd_url" {
  description = "Access ArgoCD using this URL"
  value       = "http://${aws_instance.devops_server.public_ip}:8081"
}

output "nexus_url" {
  description = "Access Nexus Repository using this URL"
  value       = "http://${aws_instance.devops_server.public_ip}:8082"
}

output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.devops_server.public_ip
}
