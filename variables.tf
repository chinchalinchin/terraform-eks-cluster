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

variable "control_plane_sg_ids"{
    description = "List of security groups ID into which the control plane deploys"
    type = list 
}
# defaultable

