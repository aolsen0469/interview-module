#!/bin/bash
# this script is meant to be run on YOUR local
# (to configure the live-troubleshooting-module before deploying / scp to bastion host)

set -x
WORKING_DIR='../live-troubleshooting-modules'
ING_DIR="./k8s-rails-todo-list/ingress-nginx"
cd ${WORKING_DIR}

# change project
gcloud config set project techops-interview
LB_IP=$(gcloud compute addresses list | grep -i interview-ingress-ip | awk '{print $2}')

# switch kubectl context
gcloud container clusters get-credentials interview-cluster --zone northamerica-northeast1-a --project techops-interview

# Change the Ingress-controllers service LoadBalancerIp to $LB_IP
sed -ie "s/loadBalancerIP: .*/loadBalancerIP: ${LB_IP}/" ${ING_DIR}/controller-service.yaml
rm ${ING_DIR}/controller-service.yamle

# Deploy module
kustomize build k8s-rails-todo-list | kubectl apply -f-

# the goal of this is to deploy this with terraform local exec | BEFORE | the manifests scp'd to compute  

