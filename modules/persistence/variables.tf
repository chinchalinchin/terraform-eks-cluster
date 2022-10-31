variable "cluster_name" {
    description                         = "Name to assign to the cluster"
    type                                = string
    default                             = "automation-library-clsuter"
}


variable "region" {
    description                         = "Region where resources are deployed"
    type                               = string
    default                             = "us-east-1"
}


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