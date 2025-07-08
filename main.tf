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
    ami_id = data.aws_ami.ubuntu_20_04.id
}

module "vpc" {
  source     = "./modules/vpc"
  region     = var.region
  vpc_name   = "K8S VPC"
  subnet_name = "K8S Subnet"
}

module "security_group" {
  source  = "./modules/security_group"
  vpc_id  = module.vpc.vpc_id
  sg_name = "K8S Ports"
}

module "s3" {
  source       = "./modules/s3"
  bucket_prefix = "k8s-"
}

module "master" {
  source              = "./modules/ec2"
  ami_id             = local.ami_id
  instance_type      = var.instance_type
  key_name           = var.ami_key_pair_name
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security_group.security_group_id]
  bucket_name        = module.s3.bucket_name
  access_key         = var.access_key
  secret_key         = var.secret_key
  region             = var.region
  instance_role      = "msr"
  worker_number      = 1
  script_path        = "scripts/install_k8s_msr.sh"
}

module "workers" {
  source              = "./modules/ec2"
  count               = var.number_of_worker
  ami_id             = local.ami_id
  instance_type      = var.instance_type
  key_name           = var.ami_key_pair_name
  subnet_id          = module.vpc.subnet_id
  security_group_ids = [module.security_group.security_group_id]
  bucket_name        = module.s3.bucket_name
  access_key         = var.access_key
  secret_key         = var.secret_key
  region             = var.region
  instance_role      = "wrk"
  worker_number      = count.index + 1
  script_path        = "scripts/install_k8s_wrk.sh"
  
  depends_on = [
    module.master
  ]
}