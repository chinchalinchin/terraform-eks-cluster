# unique
variable "cluster_role_arn" {
    description = "IAM role arn for EKS cluster"
    type = string
}

variable "node_role_arn" {
    description = "IAM role arn for EKS Node Group"
    type = string
}

variable "kms_key_arn" {
    description = "Customer managed key ARN for AWS KMS"
    type = string
}

variable "subnet_ids"{
    description = "List of subnet IDs into which to cluster pods"
    type = list
}

variable "control_plane_sg_ids" {
    description = "List of security group IDs into which the control plane deploys"
    type = list 
}

variable "remote_access_sg_ids" {
    description = "List of security group IDs which are allowed ingress into the cluster"
    type = list
}

# NOTE: this key must exist in the keyring before launching this terraform module.
#       Refer to docs/source/QUICKSTART.md for more information
variable "ec2_ssh_key" {
    description = "Name of the public SSH key in the EC2 keyring"
    type = string
}

# defaultable

