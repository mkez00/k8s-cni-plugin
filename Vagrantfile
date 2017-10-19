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

      # initialize
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

    SHELL
  end

# script used to provision nodes
$node_script = <<-SHELL
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

        # make directory for CNI configurations and copy config file
        mkdir -p /etc/cni/net.d
        cp -f /data/$1/10-bridge.conf /etc/cni/net.d/

        # join node to cluster
        kubeadm join --token b9e6bb.6746bcc9f8ef8267 192.168.56.10:6443

        # install strongswan and configure connections
        apt-get install strongswan -y
        cp -f /data/$1/ipsec.conf /etc/ipsec.conf
        cp -f /data/$1/ipsec.secrets /etc/ipsec.secrets
        cp -f /data/$1/strongswan.conf /etc/strongswan.conf

        # script which connects strongswan nodes
        cp -f /data/strong-swan-start.sh /opt/
        chmod 0755 /opt/strong-swan-start.sh
  SHELL

  # we need 3 nodes
  $num_node = 3
  $num_node.times do |n|
    node_vm_name = "node#{n+1}"
    hostname = "node-#{n+1}"
    private_ip = "192.168.56.1#{n+1}"
    config.vm.define node_vm_name do |c|
      c.vm.box = "ubuntu/xenial64"
      c.vm.synced_folder "data", "/data"
      c.vm.hostname = hostname
      c.vm.network "private_network", ip: private_ip
      c.vm.provision "shell", run: "always" do |s|
        s.inline = $node_script
        s.args = node_vm_name
      end
    end
  end

 end