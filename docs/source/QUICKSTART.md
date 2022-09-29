# Quickstart 

## eksctl

### Generate SSH key locally

This key will be used to allow SSH access to the Pods running the cluster. See `ssh` property of the _eks/ec2-cluster-config.yaml_.

```shell
ssh-keygen -t ed25519 -f ~/.ssh/ec2_id_ed25519
```