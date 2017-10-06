#!/bin/bash

sudo apt-get install ebtables ethtool

sudo apt-get update
sudo apt-get install -y docker.io

sudo apt-get update && apt-get install -y apt-transport-https
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
sudo apt-get install kubelet kubeadm kubectl -y --allow-unauthenticated

# required as per https://github.com/kubernetes/kubernetes/issues/53356
sudo rm -rf /var/lib/kubelet/pki
sudo kubeadm reset

# initialize(pod-network-cidr parameter is for Flannel)
sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --token=b9e6bb.6746bcc9f8ef8267 --pod-network-cidr=10.244.0.0/16

# setup kubectl for root
sudo mkdir -p /root/.kube
sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

# setup kubectl for ubuntu user
sudo mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config

# Weave Net
# export kubever=$(kubectl version | base64 | tr -d '\n')
# sudo kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"

# Flannel
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel.yml
sudo kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/v0.8.0/Documentation/kube-flannel-rbac.yml

# Deployment
# kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080

#Expose as service
# will export to nodes.  So curl http://192.168.56.11:<assigned_port> should return with response
# kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

# Scaled
# kubectl scale deployments/kubernetes-bootcamp --replicas=3
