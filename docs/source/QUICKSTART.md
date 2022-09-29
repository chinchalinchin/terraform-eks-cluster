# Quickstart 

## Local Setup

### Environment Variables

Copy _.sample.env_ into a new _.env_ environment variable, adjust the variables and then load it into your shell session,

```shell
cp ./.sample.env ./.env
# adjust values
source ./.env
```

These values are passed into **Terraform** through the [TF_VAR syntax](https://www.terraform.io/cli/config/environment-variables), rather than the _.tfvars_ file, to avoid committing sensitive information to version control.

## Remote Access

### Generate SSH Key Pair

This key will be used to allow SSH access to the Pods running the cluster. Generate the key locally with the following command,

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

Take note of this key-name. It is used an input into the **Terraform** module.

