variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t3.medium"
}

variable "ami_id" {
  description = "Ubuntu AMI ID"
  default     = "ami-0c55b159cbfafe1f0"  # Change this based on AWS region
}

variable "key_name" {
  description = "SSH Key Pair Name"
  default     = "my-key-pair"
}

variable "security_group" {
  description = "Security Group for EC2"
  default     = "sg-12345678"  # Replace with actual security group ID
}
