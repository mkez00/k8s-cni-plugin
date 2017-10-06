#!/bin/bash

sudo apt install ebtables ethtool

sudo apt-get update
sudo apt-get install -y docker.io

sudo apt-get update && apt-get install -y apt-transport-https
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get install -y kubelet kubeadm kubectl

# required as per https://github.com/kubernetes/kubernetes/issues/53356
sudo rm -rf /var/lib/kubelet/pki
sudo kubeadm reset

# initialize
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --token=b9e6bb.6746bcc9f8ef8267

# setup kubectl
sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config
# sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Weave Net.....for now!
export kubever=$(kubectl version | base64 | tr -d '\n')
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"