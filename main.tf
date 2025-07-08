provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "aws_ami" "ubuntu_20_04" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  owners = ["099720109477"] # Canonical's AWS account ID
}

locals {
  private_key_path = "${path.module}/keys/${var.ami_key_pair_name}.pem"
  key_name         = var.ami_key_pair_name
  master_ami_id    = data.aws_ami.master.id
  worker_ami_id    = data.aws_ami.worker.id

}

module "vpc" {
  source      = "./modules/vpc"
  region      = var.region
  vpc_name    = "K8S VPC"
  subnet_name = "K8S Subnet"
}

module "security_group" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
  sg_name = "K8S Ports"
}
module "keypair" {
  source   = "./modules/keypair"
  key_name = local.key_name
  key_path = local.private_key_path

}

# Main configuration for the Kubernetes cluster
module "master" {
  source               = "./modules/ec2"
  ami_id               = local.master_ami_id
  instance_type        = "t3.medium"
  instance_role        = "msr"
  subnet_id            = module.vpc.subnet_id
  security_group_ids   = [module.security_group.security_group_id]
  pod_cidr             = "192.168.0.0/16"
  key_name             = local.key_name
  ssh_private_key_path = local.private_key_path
}

module "workers" {
  count                = 2
  source               = "./modules/ec2"
  ami_id               = local.worker_ami_id
  key_name             = local.key_name
  instance_type        = "t3.medium"
  instance_role        = "wrk"
  worker_number        = count.index + 1
  subnet_id            = module.vpc.subnet_id
  security_group_ids   = [module.security_group.security_group_id]
  master_private_ip    = module.master.private_ip
  ssh_private_key_path = local.private_key_path
  depends_on = [
    module.master
  ]
}