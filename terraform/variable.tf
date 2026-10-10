
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-0b6d9d3d33ba97d99"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_pair" {
  description = "Existing AWS EC2 key pair"
  type        = string
  default     = "demo"
}

variable "ssh_cidr" {
  description = "CIDR allowed to access SSH"
  type        = string
  default     = "0.0.0.0/0"
}
variable "deployments" {
  description = "Deployment identifiers for EC2 instances"
  type        = list(string)
  default     = ["deployment-002"]
}