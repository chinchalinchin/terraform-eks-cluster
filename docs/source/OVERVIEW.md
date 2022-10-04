# aws-eks-managed-cluster

A **Terraform** module for a deploying an **EKS** cluster with **AWS ECS** managed nodes.

<!-- BEGIN_TF_DOCS -->
  Placeholder for Terraform Docs
<!-- END_TF_DOCS -->

## References
### Repositories
- [aws/amazon-vpc-cni-k8s](https://github.com/aws/amazon-vpc-cni-k8s)
- [kubernetes-sigs/external-dns](https://github.com/kubernetes-sigs/external-dns)
### AWS EC2 Documentation
- [Accessing Linux Instances](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AccessingInstancesLinux.html)
### AWS EKS Documentation
- [Security Best Practices](https://aws.github.io/aws-eks-best-practices/security/docs/)
- [Security Group Considerations](https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html)
- [Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Deploying a Sample Application](https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html)
- [Proposal: CNI Plugin For Kubernetes networking over AWS VPC](https://github.com/aws/amazon-vpc-cni-k8s)
- [VPC Considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
- [Cluster Endpoint Access](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)
### eksctl Documentation
- [Introduction](https://eksctl.io/introduction/)
- [eksctl Config Samples](https://github.com/weaveworks/eksctl/tree/main/examples)
### ExternalDNS Documentation
- [ExternalDNS for AWS](https://github.com/kubernetes-sigs/external-dns/blob/master/docs/tutorials/aws.md)
### Gitlab Documentation
- [Docker Image](https://docs.gitlab.com/ee/install/docker.html)
- [Helm Chart](https://docs.gitlab.com/charts/)
- [Test Gitlab on AWS EKS](https://docs.gitlab.com/charts/quickstart/)
- [AWS EKS Resources](https://docs.gitlab.com/charts/installation/cloud/eks.html)
- [Global Configuration](https://docs.gitlab.com/charts/charts/globals.html)
- [AWS Setup](https://docs.gitlab.com/charts/installation/cloud/eks.html)
- [Use AWS ACM to Manage Certificates](https://docs.gitlab.com/charts/installation/tls.html#use-aws-acm-to-manage-certificates)
- [Issue: Install Helm Chart Without Domain?](https://gitlab.com/gitlab-org/charts/gitlab/-/issues/3182)
### Kubernetes Documentation
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Service: SSL Support on AWS](https://kubernetes.io/docs/concepts/services-networking/service/#ssl-support-on-aws)
### Terraform Documentation
- [EKS Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
- [EKS Node Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)
- [Key Pair](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair)
- [KMS Key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key)
- [Security Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group)
- [Security Group Rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule)

## Utilties
- [yq: JSON-to-YAML mapping CLI](https://mikefarah.gitbook.io/yq/)