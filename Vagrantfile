# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.define "master" do |c|
	  c.vm.box = "ubuntu/xenial64"
    c.vm.synced_folder "data", "/data"
    c.vm.hostname = 'master'
    c.vm.network "private_network", ip: "192.168.56.10"
    c.vm.provision "shell", inline: <<-SHELL
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

      # make directory for CNI config
      sudo mkdir -p /etc/cni/net.d
      # provide cni config (does not copy to nodes)
      sudo cp -f /data/10-bridge.conf /etc/cni/net.d/

      # initialize(pod-network-cidr parameter is for Flannel --pod-network-cidr=10.244.0.0/16)
      sudo kubeadm init --apiserver-advertise-address=192.168.56.10 --token=b9e6bb.6746bcc9f8ef8267 

      # setup kubectl for root
      sudo mkdir -p /root/.kube
      sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config

      # setup kubectl for ubuntu user
      sudo mkdir -p /home/ubuntu/.kube
      sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
      sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config


      # Deployment
      sudo kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080

      #Expose as service
      # will export to nodes.  So curl http://192.168.56.11:<assigned_port> should return with response
      # sudo kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

    SHELL
  end

  config.vm.define "node1" do |c|
	c.vm.box = "ubuntu/xenial64"
    c.vm.synced_folder "data", "/data"
    c.vm.hostname = 'node-1'
    c.vm.network "private_network", ip: "192.168.56.11"
    c.vm.provision "shell", inline: <<-SHELL

      sudo su

      apt-get install ebtables ethtool

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

      # make directory for CNI config
      mkdir -p /etc/cni/net.d
      # provide cni config (does not copy to nodes)
      cp -f /data/node1/10-bridge.conf /etc/cni/net.d/
      cp -f /data/node1/20-sswan.conf /etc/cni/net.d/

      kubeadm join --token b9e6bb.6746bcc9f8ef8267 192.168.56.10:6443

      # install strongswan and configure nodes
      apt-get install strongswan -y
      cp -f /data/node1/ipsec.conf /etc/ipsec.conf
      cp -f /data/node1/ipsec.secrets /etc/ipsec.secrets
      cp -f /data/node1/strongswan.conf /etc/strongswan.conf

      # apply the changes by restarting strongswan service
      #systemctl restart strongswan.service
      #ipsec restart

      # copy CNI plugin to dir
      cp -f  /data/strong-swan /opt/cni/bin

    SHELL

  end

  config.vm.define "node2" do |c|
	c.vm.box = "ubuntu/xenial64"
    c.vm.synced_folder "data", "/data"
    c.vm.hostname = 'node-2'
    c.vm.network "private_network", ip: "192.168.56.12"
    c.vm.provision "shell", inline: <<-SHELL

      sudo su

      apt-get install ebtables ethtool

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

      # make directory for CNI config
      sudo mkdir -p /etc/cni/net.d
      # provide cni config (does not copy to nodes)
      sudo cp -f /data/node2/10-bridge.conf /etc/cni/net.d/
      sudo cp -f /data/node2/20-sswan.conf /etc/cni/net.d/

      kubeadm join --token b9e6bb.6746bcc9f8ef8267 192.168.56.10:6443

      # install strongswan and configure nodes
      apt-get install strongswan -y
      cp -f /data/node2/ipsec.conf /etc/ipsec.conf
      cp -f /data/node2/ipsec.secrets /etc/ipsec.secrets
      cp -f /data/node2/strongswan.conf /etc/strongswan.conf

      # apply the changes by restarting strongswan service
      #systemctl restart strongswan.service
      #ipsec restart

      # copy CNI plugin to dir
      cp -f  /data/strong-swan /opt/cni/bin

    SHELL
  end

  config.vm.define "node3" do |c|
	c.vm.box = "ubuntu/xenial64"
    c.vm.hostname = 'node-3'
    c.vm.synced_folder "data", "/data"
    c.vm.network "private_network", ip: "192.168.56.13"
    c.vm.provision "shell", inline: <<-SHELL

      sudo su

      apt-get install ebtables ethtool

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

      # make directory for CNI config
      sudo mkdir -p /etc/cni/net.d
      # provide cni config (does not copy to nodes)
      sudo cp -f /data/node3/10-bridge.conf /etc/cni/net.d/
      sudo cp -f /data/node3/20-sswan.conf /etc/cni/net.d/

      kubeadm join --token b9e6bb.6746bcc9f8ef8267 192.168.56.10:6443

      # install strongswan and configure nodes
      apt-get install strongswan -y
      cp -f /data/node3/ipsec.conf /etc/ipsec.conf
      cp -f /data/node3/ipsec.secrets /etc/ipsec.secrets
      cp -f /data/node3/strongswan.conf /etc/strongswan.conf

      # apply the changes by restarting strongswan service
      #systemctl restart strongswan.service
      #ipsec restart

      # copy CNI plugin to dir
      cp -f  /data/strong-swan /opt/cni/bin

    SHELL
  end

 end