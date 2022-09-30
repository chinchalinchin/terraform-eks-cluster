resource "aws_kms_key" "automation_library_key" {
    description             = "KMS key for encrypting cluster secrets"
    deletion_window_in_days = 10
    enable_key_rotation     = true
    custom_master_key_spec  = "SYMMETRIC_DEFAULT"
    custom_key_store_id     = "automation-library-cluster-key"
    key_usage               = "ENCRYPT_DECRYPT"
    is_enabled              = true
}

resource "aws_security_group" "control_plane_sg" {
    name        = "control-plane-sg"
    description = "Allow TLS inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        description      = "VPC Ingress"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        description      = "VPC Egress"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_tls"
    }
} 
resource "aws_security_group" "remote_access_sg" {
    name        = "remote-access-sg"
    description = "Allow TLS inbound traffic"
    vpc_id      = var.vpc_id

    ingress {
        description      = "VPC Ingress"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        description      = "VPC Egress"
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    tags = {
        Name = "allow_tls"
    }
} 

resource "aws_eks_cluster" "automation_library_cluster" {
    name                        = "automation-library-cluster"
    
    role_arn                    = var.cluster_role_arn

    enabled_cluster_log_types   = [
        "api", 
        "audit", 
        "authenticator", 
        "controllerManager", 
        "scheduler"
    ]

    encryption_config {
        resources   = [
            "secrets"
        ]

        provider {
            key_arn = aws_kms_key.automation_library_key.arn
        }
    }

    vpc_config {
        subnet_ids              = var.subnet_ids
        security_group_ids      = aws_security_group.control_plane_sg.*.id
        endpoint_private_access = true
        endpoint_public_access  = false
    }

}

resource "aws_eks_node_group" "automation-library-ng1" {
    cluster_name        = aws_eks_cluster.automation_library_cluster.name
    instance_types      = [
        "t3.medium"
    ]
    node_group_name     = "automation-library-node-group-1"
    node_role_arn       = var.node_role_arn
    subnet_ids          = var.subnet_ids

    scaling_config {
      desired_size      = 1
      max_size          = 2
      min_size          = 1
    }

    update_config {
      max_unavailable   = 1
    }

    remote_access {
        ec2_ssh_key                 = var.ec2_ssh_key
        source_security_group_ids   = aws_security_group.remote_access_sg.*.id
    }
}

output "endpoint" {
    value = aws_eks_cluster.automation_library_cluster.endpoint
}

output "kubeconfig-certificate-authority-data" {
    value = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}

output "kms-key-arn" {
    value = aws_kms_key.automation_library_key.arn
}

output "kms-key-id" {
    value = aws_kms_key.automation_library_key.id
}