#!/bin/bash

# Configuration du hostname
hostname k8s-wrk-${worker_number}
echo "k8s-wrk-${worker_number}" > /etc/hostname

# Attente que le master soit prêt
until nc -z ${master_ip} 6443; do
  sleep 10
done

# Récupération du join command
scp -o StrictHostKeyChecking=no ubuntu@${master_ip}:/home/ubuntu/join_command.sh /tmp/
chmod +x /tmp/join_command.sh

# Join du cluster
/tmp/join_command.sh