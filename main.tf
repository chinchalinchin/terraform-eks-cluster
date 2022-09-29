resource "aws_eks_cluster" "automation_library_cluster" {
    name     = "automation-library-cluster"
    
    role_arn = var.cluster_role_arn

    enabled_cluster_log_types = [
        "api", 
        "audit", 
        "authenticator", 
        "controllerManager", 
        "scheduler"
    ]

    encryption_config {
        resources = ["secrets"]
        provider {
            key_arn = var.kms_key_arn
        }
    }

    vpc_config {
        subnet_ids = var.subnet_ids
        security_group_ids = var.security_group_ids
        endpoint_private_access = true
        endpoint_public_access = false
    }

}

resource "aws_eks_node_group" "automation-library-ng1" {
    cluster_name = aws_eks_cluster.automation_library_cluster.name
    instance_types = [
        "t3.medium"
    ]
    node_group_name = "automation-library-node-group-1"
    node_role_arn = var.node_role_arn
    subnet_ids = var.subnet_ids

    scaling_config {
      desired_size = 1
      max_size = 2
      min_size = 1
    }

    update_config {
      max_unavailable = 1
    }

    remote_access {
        ec2_ssh_key = var.ec2_ssh_key
        source_security_group_ids = var.remote_access_sg_ids
    }
}

output "endpoint" {
    value = aws_eks_cluster.automation_library_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}