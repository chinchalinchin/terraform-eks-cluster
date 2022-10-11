# aws-eks-managed-cluster

A **Terraform** module for a deploying an **EKS** cluster with **AWS ECS** managed nodes.

<!-- BEGIN_TF_DOCS -->
  Placeholder for Terraform Docs
<!-- END_TF_DOCS -->

## References
### Repositories
- [aws/amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
- [aws-quickstart/quickstart-eks-gitlab](https://github.com/aws-quickstart/quickstart-eks-gitlab)
- [gitlab-org/gitlab-environment-toolkit](https://gitlab.com/gitlab-org/gitlab-environment-toolkit/-/tree/main)
- [kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns)
- [kubernetes-sigs/aws-ebs-csi-driver](https://github.com/kubernetes-sigs/aws-ebs-csi-driver)
### Guides
- [EKS Gitlab Quickstart](https://aws-quickstart.github.io/quickstart-eks-gitlab/)
### AWS Documentation
- [Elastic IPs](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/elastic-ip-addresses-eip.html#using-instance-addressing-eips-allocating)
### AWS EKS Documentation
- [Security Best Practices](https://aws.github.io/aws-eks-best-practices/security/docs/)
- [Security Group Considerations](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html)
- [Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Deploying a Sample Application](https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html)
- [Proposal: CNI Plugin For Kubernetes networking over AWS VPC](https://github.com/aws/amazon-vpc-cni-k8s)
- [VPC Considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
- [Cluster Endpoint Access](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)
- [EBS Container Storage Interface Plugin](https://docs.aws.amazon.com/eks/latest/userguide/ebs-csi.html)
### Gitlab Documentation
- [Docker Image](https://docs.gitlab.com/ee/install/docker.html)
- [Helm Chart](https://docs.gitlab.com/charts/)
- [Test Gitlab on AWS EKS](https://docs.gitlab.com/charts/quickstart/)
- [AWS EKS Cloud Resources](https://docs.gitlab.com/charts/installation/cloud/eks.html)
- [Global Configuration](https://docs.gitlab.com/charts/charts/globals.html)
- [Use AWS ACM to Manage Certificates](https://docs.gitlab.com/charts/installation/tls.html#use-aws-acm-to-manage-certificates)
- [Issue: Install Helm Chart Without Domain?](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/3182)
### Kubernetes Documentation
- [Service: SSL Support on AWS](https://kubernetes.io/docs/concepts/services-networking/service/#ssl-support-on-aws)
- [Volume: AWS EBS Configuration](https://kubernetes.io/docs/concepts/storage/volumes/#aws-ebs-configuration-example)
### Terraform Documentation
- [EKS Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
- [EKS Node Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)
- [EC2 Instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance)
- [Instance Profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile)
- [Key Pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
- [KMS Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)
- [Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [Security Group Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)
### Stack Overflow
- [Determine Terraform Module Least Permissions](https://stackoverflow.com/questions/51273227/whats-the-most-efficient-way-to-determine-the-minimum-aws-permissions-necessary)