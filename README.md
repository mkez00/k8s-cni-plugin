# k8s-cni-plugin

After vagrant up.  Need to do the following:

1) Scale number of pods (master): sudo kubectl scale deployments/kubernetes-bootcamp --replicas=9
1b) Restart StrongSwan service on all nodes?????
2) Connect IPSec tunnel to nodes (node1): sudo ipsec up net-net-node2 && sudo ipsec up net-net-node3
3) Get to container's shell on node1: sudo docker exec -i -t <CONTAINER_NAME> /bin/bash
4) Get to container's shell on node2: sudo docker exec -i -t <CONTAINER_NAME> /bin/bash
5) Get IP of container on node2: ip addr OR get it from master using sudo kubectl describe pods <POD_NAME>
6) Ping IP of container on node2 from container on node1: ping <CONTAINER_IP>
7) Watch traffic on interface created by CNI plugin on node2: sudo tcpdump -i cni0