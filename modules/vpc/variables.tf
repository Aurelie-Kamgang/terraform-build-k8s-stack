variable "region" {
  description = "AWS region"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "vpc_name" {
  description = "Name tag for VPC"
  type        = string
  default     = "K8S VPC"
}

variable "subnet_name" {
  description = "Name tag for subnet"
  type        = string
  default     = "K8S Subnet"
}

variable "igw_name" {
  description = "Name tag for internet gateway"
  type        = string
  default     = "K8S Internet Gateway"
}

variable "rt_name" {
  description = "Name tag for route table"
  type        = string
  default     = "Public Route Table"
}