resource "aws_instance" "this" {
  ami                         = var.ami_id
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group_ids
  
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "16"
    delete_on_termination = true
  }

  tags = {
    Name = "k8s_${var.instance_role}_${var.worker_number}"
  }

  user_data_base64 = base64encode(templatefile(var.script_path, {
    access_key    = var.access_key
    private_key   = var.secret_key
    region        = var.region
    s3buckit_name = var.bucket_name
    worker_number = var.worker_number
  }))
}