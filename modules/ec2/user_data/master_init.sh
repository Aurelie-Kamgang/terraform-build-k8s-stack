#!/bin/bash

# Initialisation du cluster
kubeadm init \
  --pod-network-cidr=${pod_cidr} \
  --apiserver-advertise-address=$(hostname -I | awk '{print $1}') \
  --upload-certs

# Configuration kubectl
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Installation de Calico
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.26.1/manifests/calico.yaml

# Préparation du join command
kubeadm token create --print-join-command > /home/ubuntu/join_command.sh
chmod 644 /home/ubuntu/join_command.sh