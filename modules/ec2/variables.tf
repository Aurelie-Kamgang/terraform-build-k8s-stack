variable "ami_id" {
  description = "AMI ID for EC2 instances"
  type        = string
}

variable "instance_role" {
  description = "Role de l'instance (msr ou wrk)"
  type        = string
  validation {
    condition     = contains(["msr", "wrk"], var.instance_role)
    error_message = "Le rôle doit être 'msr' (master) ou 'wrk' (worker)."
  }
}

variable "pod_cidr" {
  description = "CIDR pour le réseau Pod"
  type        = string
  default     = "192.168.0.0/16"
}

variable "master_private_ip" {
  description = "IP privée du master (pour les workers)"
  type        = string
  default     = ""
}

variable "ssh_private_key_path" {
  description = "Chemin vers la clé SSH pour provisionnement"
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

variable "worker_number" {
  description = "Worker number for naming"
  type        = number
  default     = 1
}

variable "s3_bucket_name" {
  type        = string
  description = "Nom du bucket S3 pour stocker join_command.sh"
}

variable "iam_instance_profile" {
  description = "Le nom de l'Instance Profile à attacher aux EC2 pour accéder à S3"
  type        = string
}