# unique
variable "cluster_role_arn" {
    description = "IAM role arn for EKS cluster"
    type = string
}

variable "subnet_ids"{
    description = "List of subnet IDs into which to deploy Fargate pods"
    type = list
}

variable "security_group_ids"{
    description = "List of security IDs into which to deploy Fargate pods"
    type = list 
}
# defaultable

