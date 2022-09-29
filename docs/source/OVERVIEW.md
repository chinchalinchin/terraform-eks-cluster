# aws-eks-fargate-cluster


## Setup

### Cluster Role

This service role already exists in **NorthernLights** under the name, `AWSRoleForEKS`,

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


### Pod Execution Role

In order for Fargate to manage EKS pods for our cluster, we need a role `AutomationLibraryEKSPodExecutionRole` with the following policy,

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Condition": {
         "ArnLike": {
            "aws:SourceArn": "arn:aws:eks:<account-region>:<account-number>:fargateprofile/automation-library*/*"
         }
      },
      "Principal": {
        "Service": "eks-fargate-pods.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

## References
### AWS EKS Documentation
- [Getting Started](https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)
- [Fargate Profile](https://docs.aws.amazon.com/eks/latest/userguide/fargate-profile.html)
- [Deploying a Sample Application](https://docs.aws.amazon.com/eks/latest/userguide/sample-deployment.html)
- [Pod Execution IAM Role](https://docs.aws.amazon.com/eks/latest/userguide/pod-execution-role.html)
- [VPC Considerations](https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html)
### eksctl Documentation
- [Introduction](https://eksctl.io/introduction/)
- [Fargate Support](https://eksctl.io/usage/fargate-support/)
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