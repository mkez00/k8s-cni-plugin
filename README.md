# k8s-cni-plugin

Demonstrate the use of StrongSwan based IPSec in a 3 node Kubernetes cluster.  Each node uses bridge + host-local CNI.

After vagrant up.  Demonstrate connectivity by doing the following:

1) Scale number of pods (master): sudo kubectl scale deployments/kubernetes-bootcamp --replicas=9
2) Run StrongSwan startup script on each node (node1, node2, node3): sudo /opt/strong-swan-start.sh
3) Open shell in container on node1: sudo docker exec -i -t <CONTAINER_NAME> /bin/bash
4) Open shell in container on node2: sudo docker exec -i -t <CONTAINER_NAME> /bin/bash
5) Get IP of container on node2: ip addr OR get it from master using sudo kubectl describe pods <POD_NAME>
6) Ping IP of container on node2 from container on node1: ping <CONTAINER_IP>
7) Watch traffic on interface created by CNI plugin on node2: sudo tcpdump -i cni0
8) Stop ipsec on any node to sever link between hosts and observe ping no longer getting response: sudo ipsec stop