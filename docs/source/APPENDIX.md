# References
## Repositories
- [aws/amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
- [aws-quickstart/quickstart-eks-gitlab](https://github.com/aws-quickstart/quickstart-eks-gitlab)
- [gitlab-org/gitlab-environment-toolkit](https://gitlab.com/gitlab-org/gitlab-environment-toolkit/-/tree/main)
- [kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns)
- [kubernetes-sigs/aws-ebs-csi-driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
## Guides
- [EKS Gitlab Quickstart](https://aws-quickstart.github.io/quickstart-eks-gitlab/)
## AWS Documentation
### EC2
- [Elastic IPs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-allocating)
## EKS
- [Security Best Practices](https://aws.github.io/aws-eks-best-practices/security/docs/)
- [Security Group Considerations](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html)
- [OIDC Identity Provider](https://docs.aws.amazon.com/eks/latest/userguide/authenticate-oidc-identity-provider.html)
- [VPC Considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
- [Cluster Endpoint Access](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)
- [Storage Classes](https://docs.aws.amazon.com/eks/latest/userguide/storage-classes.html)
- [EBS Container Storage Interface Plugin](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
## Gitlab Documentation
### Gitlab 
- [Docker Image](https://docs.gitlab.com/ee/install/docker.html)
- [Helm Chart](https://docs.gitlab.com/charts/)
- [Test Gitlab on AWS EKS](https://docs.gitlab.com/charts/quickstart/)
- [AWS EKS Cloud Resources](https://docs.gitlab.com/charts/installation/cloud/eks.html)
- [Global Configuration](https://docs.gitlab.com/charts/charts/globals.html)
- [Use AWS ACM to Manage Certificates](https://docs.gitlab.com/charts/installation/tls.html#use-aws-acm-to-manage-certificates)
- [Configure External PostgresSQL](https://docs.gitlab.com/charts/advanced/external-db/index.html)
- [Configure External Redis](https://docs.gitlab.com/charts/advanced/external-redis/index.html)
### Gitlab Runner
- [Install Runner](https://docs.gitlab.com/runner/)
- [Helm Chart](https://docs.gitlab.com/runner/install/kubernetes.html)
## Kubernetes Documentation
- [Service: SSL Support on AWS](https://kubernetes.io/docs/concepts/services-networking/service/#ssl-support-on-aws)
- [Volume: AWS EBS Configuration](https://kubernetes.io/docs/concepts/storage/volumes/#aws-ebs-configuration-example)
- [RBAC](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
## Terraform Documentation
### EKS
- [eks_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
- [eks_node_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)
### EC2
- [instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
### IAM
- [iam_instance_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)
- [key_pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
### KMS
- [kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)
### RDS
- [db_instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_instance)
- [db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)
### SM
- [secretsmanger_secret](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret)
- [secretsmanager_secret_version](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version)
### VPC
- [db_subnet_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group)
- [security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)
### Data Sources
- [certificate](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate)
## Stack Overflow
- [Determine Terraform Module Least Permissions](https://stackoverflow.com/questions/51273227/whats-the-most-efficient-way-to-determine-the-minimum-aws-permissions-necessary)