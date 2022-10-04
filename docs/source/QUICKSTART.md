# Quickstart 

## Local Setup

### Requirements
- [kubectl]()
- [awscli]()
- [helm]()
  
### Environment Variables

Copy _.sample.env_ into a new _.env_ environment variable, adjust the variables and then load it into your shell session,

```shell
cp ./.sample.env ./.env
# adjust values
source ./.env
```

These values are passed into **Terraform** through the [TF_VAR syntax](https://www.terraform.io/cli/config/environment-variables), rather than the _.tfvars_ file, to avoid committing sensitive information to version control.

## Remote Access

### Generate SSH Key Pair

This key will be used to allow SSH access to the Pods running the cluster. Generate the key locally with the following command,

```shell
ssh-keygen \
    -t rsa \
    -C "al_cluster_key" \
    -f ~/.ssh/al_cluster_key
```

### Import Public Key into EC2 Keyring

Import the key into the **EC2** keyring using the [following command](https://docs.aws.amazon.com/cli/latest/reference/ec2/import-key-pair.html),

```shell
aws ec2 import-key-pair \
    --key-name al_cluster_key \
    --public-key-material fileb://~/.ssh/al_cluster_key.pub
```

Take note of this key-name. It is used as an input into the **Terraform** module.

## AWS Setup

### Cluster Role

The **EKS** cluster needs a service role to assume, 

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

[See AWS EKS Cluster Role docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html)

### Node Role

Nodes need an IAM role with the following managed policies attached: `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly`, `AmazonEKS_CNI_Policy`. 

[See AWS EKS Node Role docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

### Kube Config

After **Terraform** has deployed the **EKS** cluster, update your local _kubeconfig_ to point to the cluster on **EKS** ([Step 3: AWS EKS Setup Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)),

```shell
aws eks update-kubeconfig \
  --region us-east-1 \
  --name automation-library-cluster
```