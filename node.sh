#!/bin/bash

sudo su

apt install ebtables ethtool

apt-get update
apt-get install -y docker.io

apt-get update && apt-get install -y apt-transport-https
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
apt-get update
apt-get install kubelet kubeadm kubectl -y --allow-unauthenticated

# skip preflight checklist required as per https://github.com/kubernetes/kubernetes/issues/53356
rm -rf /var/lib/kubelet/pki
kubeadm reset

kubeadm join --token b9e6bb.6746bcc9f8ef8267 192.168.56.10:6443