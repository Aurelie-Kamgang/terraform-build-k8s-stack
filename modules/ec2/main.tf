resource "aws_instance" "this" {
  ami                         = var.ami_id
  subnet_id                   = var.subnet_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  
  root_block_device {
    volume_type           = "gp2"
    volume_size           = "50"
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

provisioner "file" {
  source = "./scripts/init.sh"
  destination = "/tmp/init.sh"

  connection {
     type        = "ssh"
     user        = "ubuntu"
     private_key = file(var.ssh_private_key_path)
     host        = self.public_ip
   }

}

  # Provisionnement supplémentaire pour le master
 provisioner "remote-exec" {
   when = create
   inline = [
     "cloud-init status --wait",
      "chmod +x /tmp/init.sh",
      "bash /tmp/init.sh"
   ]
   
   connection {
     type        = "ssh"
     user        = "ubuntu"
     private_key = file(var.ssh_private_key_path)
     host        = self.public_ip
   }
 }

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


resource "null_resource" "remote_exec_master" {
  count = var.instance_role == "msr" ? 1 : 0

  depends_on = [aws_instance.this]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.ssh_private_key_path)
    host        = aws_instance.this.public_ip
  }

  provisioner "file" {
    source      = "./scripts/init.sh"
    destination = "/tmp/init.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "cloud-init status --wait",
      "chmod +x /tmp/init.sh",
      "bash /tmp/init.sh"
    ]
  }
}
