variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "sg_name" {
  description = "Name of the security group"
  type        = string
  default     = "K8S Ports"
}