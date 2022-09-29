# Quickstart 

## eksctl

### Generate SSH key locally

This key will be used to allow SSH access to the Pods running the cluster. See `ssh` property of the _eks/ec2-cluster-config.yaml_.

```shell
ssh-keygen \
    -t rsa \
    -C "al_cluster_key" \
    -f ~/.ssh/al_cluster_key
```

Import the key into the **EC2** keyring using the [following command](https://docs.aws.amazon.com/cli/latest/reference/ec2/import-key-pair.html),

```shell
aws ec2 import-key-pair \
    --key-name al_cluster_key \
    --public-key-material fileb://~/.ssh/al_cluster_key.pub
```

Take note of this key-name. It is used an input into the **Terraform** module.