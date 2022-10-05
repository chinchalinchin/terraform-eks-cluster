# Quickstart 

## Local Setup

### Requirements

You will need to install the following software to deploy and manage the **EKS** cluster and its associated components from your local machine.

- [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
- [helm](https://helm.sh/docs/intro/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
  
### Environment Variables

Copy _.sample.env_ into a new _.env_ environment variable, adjust the variables and then load it into your shell session,

```shell
cp ./.sample.env ./.env
# adjust values
source ./.env
```

These values are passed into **Terraform** through the [TF_VAR syntax](https://www.terraform.io/cli/config/environment-variables), rather than the _.tfvars_ file, to avoid committing sensitive information to version control.

## Remote Access

The **EKS** cluster is deployed into private subnets within the VPC, therefore it is not publicly accessible. A **EC2** bastion host gets deployed into a public subnet within the VPC where the **EKS** cluster is running; The instance has a role attached to it through its [instance profile](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) that allows it to make authenticated API calls to the cluster, allowing commands like `kubectl` and `helm` to be run against the cluster. In order to do so, you will need to remote into the aforementioned **EC2** bastion host that gets deployed as part of the module. In order to secure access to the **EC2**, the procedures below detail how to setup the key-pair in the **EC2** key ring and then use that key to SSH into it. In addition, this key is used for SSH access to the pods as well. 

### Generate SSH Key Pair

Before deploying the **Terraform** module, generate the key locally with the following command,

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

### SSH into EC2 Bastion Host

After the module has been deployed, one of its outputs, `bastion-dns`, can be used to initiate a connection with the bastion host with the following command,

```shell
ssh \
  -i ~/.ssh/al_cluster_key \
  ubuntu@<bastion-dns-goeshere>
```

**NOTE**: By default, the instance uses an Ubuntu 16 AMI, so the default user name is _ubuntu_. If you use a different AMI, you may have a different username. See [default usernames](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html#ami-default-user-names) for more information.

## AWS Setup

Before deploying the **Terraform** module, several roles must exist within the given **AWS** account.

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

The name of this role is passed in through the `cluster_role_name` variable.

[See AWS EKS Cluster Role docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html)

### Node Role

Nodes need an IAM role with the following managed policies attached: `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly`, `AmazonEKS_CNI_Policy`. 

The name of this role is passed in through the `node_role_name` variable.

[See AWS EKS Node Role docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

### EC2 Instance Profile

The **EC2** bastion host will need an instance profile provisioned and a role attached to it that permits `eks:*` and `ec2:*`

The name of this role is passed in through the `bastion_role_name` variable.

[See AWS EC2 Instance Profile docs for more information](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html)

**TODO**: Still experimenting with the exact permissions these profile will need. 

### Kube Config

After **Terraform** has deployed the **EKS** cluster, update your local _kubeconfig_ to point to the cluster on **EKS** ([Step 3: AWS EKS Setup Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)),

```shell
aws eks update-kubeconfig \
  --region us-east-1 \
  --name automation-library-cluster
```