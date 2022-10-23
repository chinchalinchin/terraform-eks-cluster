# Non-defaultable
variable "vpc_config" {
    description                     = "Configuration information for the VPC into which the cluster will deploy"
    type = object({
        id = string
        public_subnet_ids           = list(string)
        private_subnet_ids          = list(string)
    })
    sensitive                       = true
}

# Defaultable
variable "iam_config" {
    description                     = "IAM configuration for cluster roles and bastion instance profile"
    type = object({
        cluster_role_name           = string
        node_role_name              = string
        ebs_role_name               = string
        rds_monitor_role_name       = string
        bastion_profile_name        = string
    })
    default = {
        cluster_role_name           = "AWSRoleForEKS"
        node_role_name              = "AmazonEKSNodeRole"
        ebs_role_name               = "AmazonEBSforEKSRole"
        rds_monitor_role_name       = "rds-monitoring-role"
        bastion_profile_name        = "AWSRoleforECS"
    }
}