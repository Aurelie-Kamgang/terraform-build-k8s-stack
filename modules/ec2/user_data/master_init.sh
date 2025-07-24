#!/bin/bash

# Initialisation du cluster
kubeadm init \
  --pod-network-cidr=${pod_cidr} \
  --apiserver-advertise-address=$(hostname -I | awk '{print $1}') \
  --upload-certs

# Configuration kubectl
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

# Installation de Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml

# Préparation du join command
kubeadm token create --print-join-command > /home/ubuntu/join_command.sh
chmod 644 /home/ubuntu/join_command.sh

# Envoi vers S3
apt update && apt install -y awscli
aws s3 cp /home/ubuntu/join_command.sh s3://${s3_bucket_name}/join_command.sh