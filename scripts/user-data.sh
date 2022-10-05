#!/bin/bash

# NOTE: This script is used to initialize the EC2 Bastion Host that is deployed into the public subnets
#       of the VPC where the EKS cluster is running. 

## SYSTEM DEPENDENCIES
apt-get update -y
apt-get install -y \
    apt-transport-https
    ca-certificates \
    curl \

## EXTRA PACKAGE MANAGER INSTALLATIONS
### KUBERNETES
#### 1. Add Kubernetes distribution to package repository
curl -fsSLo \
    /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" |\
     tee /etc/apt/sources.list.d/kubernetes.list

### HELM
#### 2. Add Helm distribution to package repository
curl https://baltocdn.com/helm/signing.asc |\
    gpg --dearmor |\
    tee /usr/share/keyrings/helm.gpg >\
    /dev/null
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" |\
    tee /etc/apt/sources.list.d/helm-stable-debian.list

##### 3. Update and install!
apt-get update -y
apt-get install -y \
    kubectl \
    heml

## SOURCE INSTALLATIONS
### AWS CLI
"https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install


## CONFIGURATION
### 1. Add EKS Cluster to kubeconfig
aws eks update-kubeconfig \
  --region $AWS_DEFAULT_REGION \
  --name $EKS_CLUSTER_NAME