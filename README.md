# k8s-cni-plugin

After vagrant up.  Need to do the following:

1) Scale number of pods (master): sudo kubectl scale deployments/kubernetes-bootcamp --replicas=9
2) Connect IPSec tunnel (node1): sudo ipsec up net-net
3) Get to container's shell on node1: sudo docker exec -i -t <CONTAINER_NAME> /bin/bash
4) Get to container's shell on node2: sudo docker exec -i -t <CONTAINER_NAME> /bin/bash
5) Get IP of container on node2: ip addr
6) Ping IP of container on node2 from container on node1: ping <CONTAINER_IP>
7) Watch traffic on interface created by CNI plugin on node2: sudo tcpdump -i cni0