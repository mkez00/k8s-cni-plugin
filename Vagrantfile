# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  # config.vm.box = "ubuntu/xenial64"
  # config.vm.hostname = "master"
  # config.vm.provision "shell", run: "once", path: "master.sh"

  config.vm.define "master" do |c|
	c.vm.box = "ubuntu/xenial64"
    c.vm.provision "shell", run: "once", path: "master.sh"
    c.vm.hostname = 'master'
    c.vm.network "private_network", ip: "192.168.56.10"
  end

  config.vm.define "node1" do |c|
	c.vm.box = "ubuntu/xenial64"
    c.vm.provision "shell", run: "once", path: "node.sh"
    c.vm.hostname = 'node-1'
    c.vm.network "private_network", ip: "192.168.56.11"
  end

 #  config.vm.define "node2" do |c|
	# c.vm.box = "ubuntu/xenial64"
 #    c.vm.provision "shell", run: "once", path: "node.sh"
 #    c.vm.hostname = 'node-2'
 #    c.vm.network "private_network", ip: "192.168.56.12"
 #  end

 #  config.vm.define "node3" do |c|
	# c.vm.box = "ubuntu/xenial64"
 #    c.vm.provision "shell", run: "once", path: "node.sh"
 #    c.vm.hostname = 'node-3'
 #    c.vm.network "private_network", ip: "192.168.56.13"
 #  end

 end