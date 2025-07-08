output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.vpc.subnet_id
}

output "s3_bucket_name" {
  description = "Name of the created S3 bucket"
  value       = module.s3.bucket_name
}

output "master_instance_id" {
  description = "ID of the master instance"
  value       = module.master.instance_id
}

output "master_public_ip" {
  description = "Public IP of the master instance"
  value       = module.master.public_ip
}

output "worker_instance_ids" {
  description = "IDs of the worker instances"
  value       = module.workers[*].instance_id
}

output "worker_public_ips" {
  description = "Public IPs of the worker instances"
  value       = module.workers[*].public_ip
}