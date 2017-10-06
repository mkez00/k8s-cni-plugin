#!/bin/bash

# sudo apt-get update
# sudo apt-get install -y docker.io socat apt-transport-https
# curl -s -L \
#   https://storage.googleapis.com/kubeadm/kubernetes-xenial-preview-bundle.txz | tar xJv
# sudo dpkg -i kubernetes-xenial-preview-bundle/*.deb

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
apt-get install -y kubelet kubeadm kubectl

# skip preflight checklist required as per https://github.com/kubernetes/kubernetes/issues/53356
rm -rf /var/lib/kubelet/pki
kubeadm reset

kubeadm join --token b9e6bb.6746bcc9f8ef8267 192.168.56.10:6443