#!/bin/bash

## SYSTEM DEPENDENCIES
apt update -y
apt install -y \
    ubuntu-desktop \
    xrdp
apt-get update -y
apt-get install -y \
    apt-transport-https
    ca-certificates \
    curl \
    unzip

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
    helm

## SOURCE INSTALLATIONS
### AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install


## CONFIGURATION
### 1. Add EKS Cluster to kubeconfig
aws eks update-kubeconfig \
  --region ${aws_default_region} \
  --name ${eks_cluster_name}