#!/bin/bash

# Configuration du hostname
hostname k8s-wrk-${worker_number}
echo "k8s-wrk-${worker_number}" > /etc/hostname

# Attente que le master soit prêt
until nc -z ${master_ip} 6443; do
  sleep 10
done

# Récupération depuis S3
apt update && apt install -y awscli
aws s3 cp s3://${s3_bucket_name}/join_command.sh /tmp/join_command.sh
chmod +x /tmp/join_command.sh
/tmp/join_command.sh