variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID for EC2 instances"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for EC2 instances"
  type        = list(string)
}

variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "access_key" {
  description = "AWS access key"
  type        = string
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "instance_role" {
  description = "Role of the instance (master or worker)"
  type        = string
  default     = "worker"
}

variable "worker_number" {
  description = "Worker number for naming"
  type        = number
  default     = 1
}

variable "script_path" {
  description = "Path to the user data script"
  type        = string
}