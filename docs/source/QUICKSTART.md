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

The values prefixed by **TF_VAR_** are passed into **Terraform** through the [TF_VAR syntax](https://www.terraform.io/cli/config/environment-variables), rather than the _.tfvars_ file, to avoid committing sensitive information to version control. The other environment variables in this file are not necessarily to deploy the module, but are useful in administrative activities.

## Remote Access

The **EKS** cluster is deployed into private subnets within the VPC without a public endpoint, therefore it is not publicly accessible. In order to communicate with the cluster, an **EC2** bastion host gets deployed into a public subnet within the VPC where the **EKS** cluster is running; This will allow the cluster admin to SSH into the bastion host to manage the cluster.

The bastion host instance has a role attached to it through its [instance profile](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html) that allows it to make authenticated API calls to the cluster, allowing commands like `kubectl` and `helm` to be run against the cluster. 

You will need to remote into the bastion host that gets deployed as part of the module in order to manage the cluster, if `production` is set to `true`. The next few sections detail how to setup an SSH key prior to deploying the **Terraform** modules.

**NOTE**: If `production` is set to `false`, then SSH'ing into the bastion host is not neccessary, as public access is enabled to the **EKS k8s**  API in development mode. However, the bastion host still sits behind a security group with stringent ingress conditions. In this case, you must ensure `source_ips` includes any IPs that will need access to the API, as all traffic to the cluster from outside of the VPC is restricted to this whitelist.

### Generate SSH Key Pair

Before deploying the **Terraform** module, generate an SSH key locally with the following command,

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

Assuming `production` is `true`, after the module has been deployed, one of its outputs, `bastion-dns`, can be used to initiate a connection with the bastion host with the following command,

```shell
ssh \
  -i ~/.ssh/al_cluster_key \
  ubuntu@<bastion-dns-goeshere>
```

**NOTE**: By default, the instance uses an **Ubuntu** 16 AMI, so the default user name is _ubuntu_. If you use a different AMI, you may have a different username. See [default usernames](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/managing-users.html#ami-default-user-names) for more information.

## AWS Setup

Before deploying the **Terraform** module, several roles must exist within the given **AWS** account. These role names are ingested through the `vpc_config` variable.

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

Nodes need an **IAM** role with the following managed policies attached: `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly`, `AmazonEKS_CNI_Policy`. 

[See AWS EKS Node Role docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

### EBS Role

The [EBS Container Storage Plugin](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html) requires an **IAM** role with the the **AWS** managed policy `AmazonEBSCSIDriverPolicy` attached.

[See AWS EBS CSI docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html)

### EC2 Instance Profile

If deploying with `production = true`, the **EC2** bastion host will need an instance profile provisioned and a role attached to it that permits `eks:*` and `ec2:*`, at minimum.

[See AWS EC2 Instance Profile docs for more information](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_use_switch-role-ec2_instance-profiles.html)

**TODO**: Still experimenting with the exact permissions these profile will need. 

### RDS Monitoring Role

The **RDS** instances needs a role to publish logs to **CloudWatch**. This role will need the managed policy `AmazonRDSEnhancedMonitoringRole` attached to the service principlie of `monitoring.rds.amazonaws.com`

[See AWS RDS Enhanced Monitoring docs for more information](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/USER_Monitoring.OS.Enabling.html)

## Kubernetes Setup

### EKS kubeconfig

After **Terraform** has deployed the **EKS** cluster, update your local _kubeconfig_ to point to the cluster on **EKS** ([Step 3: AWS EKS Setup Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)),

```shell
aws eks update-kubeconfig \
  --region us-east-1 \
  --name automation-library-cluster
```

### Deploy Kubernetes Metric Server

This is needed for the [Kubernetes EKS Dashboard](https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html). If you do not intend to use this feature, you do not need to install the **Metrics Server**. See [documentation](https://docs.aws.amazon.com/eks/latest/userguide/metrics-server.html) for more information.

```shell
kubectl apply \
  -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
```

### PostgreSQL Password Secret

As this repository is meant to support the infrastructure for a **GitLab** deployment, the **Terraform** module deploys a **PostgreSQL** relational database service, along with all of the secondary resources necessary to support its functioning. Of interest in this section is the **SecretsManager** secret for the **Postgres RDS** that is provisioned, as this secret will need passed into a **Kubernetee** secret. After **Terraform** deploys the modules, you can grab the secret from the **SecretsManager** (you may need to adjust your **IAM** policy to allow you to retrieve the secret) and then pass it into **k8s** with the following command,

```shell
kubectl create secret generic automation-library-gitlab-postgresql-password \
    --from-literal=postgresql-password=<secret-password> \
    --from-literal=postgresql-postgres-password=<secret-password>
```

**TODO**: Create API yaml for this secret.

### Gitlab Runner Secret

Grab a registration token from the **Gitlab** UI and store it in a **Kubernetes** secret; update the _k8s/gitlab-runner-secret.yml_ and then post it to the cluster. See [documentation](https://docs.gitlab.com/runner/register/) for more information.

```shell
kubectl apply \
  -f ./k8s/gitlab-runner-secret.yml
```

## Gitlab Setup

```shell
export CERTIFICATE_ARN="arn goes here"
export DOMAIN_NAME="domain goes here"
export RDS_HOST="rds host goes here"
helm install \
  automation-library-gitlab gitlab/gitlab \
    --set nginx-ingress.controller.service.annotations="service.beta.kubernetes.io/aws-load-balancer-ssl-cert: $CERTIFICATE_ARN" \
    --set global.hosts.domain="$DOMAIN_NAME" \
    --set postgresql.install="false" \
    --set global.psql.host="$RDS_HOST" \
    --set global.psql.password.secret="automation-library-gitlab-postgresql-password" \
    --set global.psql.password.key="postgres-password"
    --set global.psql.port="5432" \
    --set global.psql.database="gitlabhq_production" \
    --set global.psql.username="gitlab"
```

Alternatively, a _values.yml_ can be found in the _helm/gitlab_ directory.

## Gitlab Runner Setup

```shell
export K8S_NAMESPACE="namespace goes here"
export GITLAB_URL="url goes here"
helm install \
  --namespace $K8S_NAMESPACE \
  automation-library-gitlab-runner gitlab/gitlab-runner \
    --set gitlabUrl=$GITLAB_URL \
    --set rbac.create="true" \
    --set runners.secret="gitlab-runner-secret" 
```

Alternatively, a _values.yml_ can be found in the _helm/runner_ directory.