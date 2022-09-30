# unique
variable "cluster_role_arn" {
    description = "IAM role arn for EKS cluster"
    type = string
}

variable "node_role_arn" {
    description = "IAM role arn for EKS Node Group"
    type = string
}

variable "vpc_id" {
    description = "Physical ID of the VPC into which the cluster will deploy"
    type = string
}

variable "subnet_ids"{
    description = "List of subnet IDs into which to cluster pods"
    type = list
}

# NOTE: this key must exist in the keyring before launching this terraform module.
#       Refer to docs/source/QUICKSTART.md for more information
variable "ec2_ssh_key" {
    description = "Name of the public SSH key in the EC2 keyring"
    type = string
}

variable "source_ips" {
    description = "IPs to whitelist for remote SSH access to pods"
    type = list
}
# defaultable

