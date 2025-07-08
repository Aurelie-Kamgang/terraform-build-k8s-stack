variable "region" {
  description = "AWS region"
  type        = string
  default = "us-east-1"
}

variable "access_key" {
  description = "AWS access key"
  type        = string
  sensitive   = true
}

variable "secret_key" {
  description = "AWS secret key"
  type        = string
  sensitive   = true
}

# variable "ami_id" {
#   description = "AMI ID for EC2 instances"
#   type        = string
# }

variable "instance_type" {
  description = "Instance type for EC2 instances"
  type        = string
}

variable "ami_key_pair_name" {
  description = "Key pair name for EC2 instances"
  type        = string
}

variable "number_of_worker" {
  description = "Number of worker nodes to create"
  type        = number
  default     = 1
}