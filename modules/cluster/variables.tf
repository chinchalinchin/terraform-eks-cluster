#### Non-defaultable variables
#### NOTE: These variables must be passed in through environment variables!
####    Do not commit their values to version control!
variable "source_ips" {
    description = "IPs to whitelist for remote SSH access to pods and ingress into the bastion host"
    type = list(string)
    sensitive = true
}

variable "vpc_config" {
    description = "Configuration information for the VPC into which the cluster will deploy"
    type = object({
        id = string
        public_subnet_ids = list(string)
        private_subnet_ids = list(string)
    })
    sensitive = true
}

#### Defaultable variables
variable "production" {
    description = "Enable production deployment"
    type = bool
    default = false
}

variable "ssh_key" {
    description = "Name of the public SSH key in the EC2 keyring. NOTE: this key must exist in the keyring before launching this Terraform moduel. Refer to QUICKSTART documentation for more information."
    type = string
    default = "al_cluster_key"
}

variable "iam_config" {
    description = "IAM configuration for cluster roles and bastion instance profile"
    type = object({
        cluster_role_name = string
        node_role_name = string
        ebs_role_name = string
        bastion_profile_name = string
    })
    default = {
        cluster_role_name = "AWSRoleForEKS"
        node_role_name = "AmazonEKSNodeRole"
        ebs_role_name = "AmazonEBSforEKSRole"
        bastion_profile_name = "AWSRoleforECS"
    }
}

variable "eks_config" {
    description = "EKS configuration for cluster and node groups."
    type = object({
        node_count = number
        instance_type = string
    })
    default = {
        node_count = 2
        instance_type = "m5.xlarge"
    }
}

variable "bastion_config" {
    description = "Configuration for the bastion host deployed into public subnet of VPC. AMI defaults to us-east-1 Ubuntu 16.04. See the following to find the image in your region: https://cloud-images.ubuntu.com/locator/ec2/"
    type = object({
        ami = string
    })
    default = {
        ami = "ami-0b0ea68c435eb488d"
    }
}