#!/bin/bash

# Deployment
sudo kubectl run kubernetes-bootcamp --image=docker.io/jocatalin/kubernetes-bootcamp:v1 --port=8080

#Expose as service
# will export to nodes.  So curl http://192.168.56.11:<assigned_port> should return with response
sudo kubectl expose deployment/kubernetes-bootcamp --type="NodePort" --port 8080

# Scaled
sudo kubectl scale deployments/kubernetes-bootcamp --replicas=3