# Quickstart 

## eksctl

### Generate SSH key locally

This key will be used to allow SSH access to the Pods running the cluster. See `ssh` property of the _eks/ec2-cluster-config.yaml_.

```shell
ssh-keygen -t ed25519 -f ~/.ssh/ec2_id_ed25519
```

Import the key into the **EC2** keyring using the [following command](https://docs.aws.amazon.com/cli/latest/reference/ec2/import-key-pair.html),

```shell
aws ec2 import-key-pair \
    --key-name al_cluster_key \
    --public-key-material file://~/.ssh/ec2_id_ed25519.pub
```

Take note of this key-name as