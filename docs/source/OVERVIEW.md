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
### eksctl Documentation
- [Introduction](https://eksctl.io/introduction/)
- [Fargate Support](https://eksctl.io/usage/fargate-support/)
### Kubernetes Documentation
- [Namespace](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/)
### Helm Documentation