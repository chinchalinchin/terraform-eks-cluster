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

output "endpoint" {
    value = aws_eks_cluster.automation_library_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}