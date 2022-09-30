resource "aws_kms_key" "automation_library_key" {
    description             = "KMS key for encrypting cluster secrets"
    deletion_window_in_days = 10
    enable_key_rotation     = true
    customer_master_key_spec  = "SYMMETRIC_DEFAULT"
    key_usage               = "ENCRYPT_DECRYPT"
    is_enabled              = true
}

resource "aws_security_group" "control_plane_sg" {
    name        = "control-plane-sg"
    description = "Allow TLS inbound traffic"
    vpc_id      = var.vpc_id

    tags = {
        organization    = "AutomationLibrary"
        team            = "BrightLabs"
        name            = "control_plane"
    }
}

resource "aws_security_group_rule" "control_plane_ingress" {
    description               = "Restrict incoming traffic to the security group itself."
    type                      = "ingress"
    from_port                 = 0
    to_port                   = 0
    protocol                  = "-1"
    security_group_id         = aws_security_group.remote_access_sg.id
    source_security_group_id  = aws_security_group.remote_access_sg.id
}

resource "aws_security_group_rule" "control_plane_egress" {
    description             = "Allow all external traffic, regardless of destination."
    type                    = "egress"
    from_port               = 0
    to_port                 = 0
    protocol                = "-1"
    cidr_blocks             = ["0.0.0.0/0"]
    security_group_id         = aws_security_group.remote_access_sg.id
}


resource "aws_security_group" "remote_access_sg" {
    name        = "remote-access-sg"
    description = "Allow inbound SSH traffic"
    vpc_id      = var.vpc_id

    ingress {
        description      = "VPC SSH Ingress"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = var.source_ips
    }

    tags = {
        oganization     = "AutomationLibrary"
        team            = "BrightLabs"
        name            = "ssh"
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
        security_group_ids      = [aws_security_group.control_plane_sg.id]
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
        source_security_group_ids   = [aws_security_group.remote_access_sg.id]
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