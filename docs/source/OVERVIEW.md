# aws-eks-managed-cluster

A **Terraform** module for a deploying an **EKS** cluster with **AWS ECS** managed nodes.

## IAM Roles

### Cluster Role

The service role for **EKS** already exists in **NorthernLights** under the name, `AWSRoleForEKS`,

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

Nodes need an IAM with the following managed policies attached: `AmazonEKSWorkerNodePolicy`, `AmazonEC2ContainerRegistryReadOnly`, `AmazonEKS_CNI_Policy`. 

[See AWS EKS Node Role docs for more information.](https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html)

### Kube Config

Update your local _kubeconfig_ to point to the cluster on **EKS** ([Step 3: AWS EKS Setup Documentation](https://docs.aws.amazon.com/eks/latest/userguide/create-cluster.html)),

```shell
aws eks update-kubeconfig \
  --region us-east-1 \
  --name automation-library-cluster
```

<!-- BEGIN_TF_DOCS -->
  Placeholder for Terraform Docs
<!-- END_TF_DOCS -->

## References
### AWS EKS Documentation
- [Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Deploying a Sample Application](https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html)
- [VPC Considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
### eksctl Documentation
- [Introduction](https://eksctl.io/introduction/)
- [eksctl Config Samples](https://github.com/weaveworks/eksctl/tree/main/examples)
### Gitlab Documentation
- [Docker Image](https://docs.gitlab.com/ee/install/docker.html)
- [Helm Chart](https://docs.gitlab.com/charts/)
- [Test Gitlab on AWS EKS](https://docs.gitlab.com/charts/quickstart/)
### Kubernetes Documentation
- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
### Terraform Documentation
- [EKS Cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster)
- [EKS Node Group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group)

## Utilties
- [yq: JSON-to-YAML mapping CLI](https://mikefarah.gitbook.io/yq/)