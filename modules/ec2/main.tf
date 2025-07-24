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

  # Configuration différenciée master/worker
  user_data_base64 = var.instance_role == "msr" ? base64encode(templatefile("${path.module}/user_data/master_init.sh", {
    pod_cidr = var.pod_cidr
    s3_bucket_name  = var.s3_bucket_name
  })) : base64encode(templatefile("${path.module}/user_data/worker_join.sh", {
    master_ip = var.master_private_ip
    worker_number = var.worker_number
    s3_bucket_name  = var.s3_bucket_name
  }))

  # Provisionnement supplémentaire pour le master
#  provisioner "remote-exec" {
#    when = create
#    inline = var.instance_role == "msr" ? [
#      "cloud-init status --wait",
#      "chmod +x /tmp/master_init.sh",
#      "/tmp/master_init.sh"
#    ] : []
#    
#    connection {
#      type        = "ssh"
#      user        = "ubuntu"
#      private_key = file(var.ssh_private_key_path)
#      host        = self.public_ip
#    }
#  }
}

# Récupération de l'IP privée du master pour les workers
data "aws_instance" "master" {
  count = var.instance_role == "wrk" ? 1 : 0
  filter {
    name   = "tag:Name"
    values = ["k8s_msr_1"]
  }
  depends_on = [aws_instance.this]
}
#locals {
#  join_command = var.instance_role == "msr" ? "" : file("/home/ubuntu/join_command.sh")
#}
