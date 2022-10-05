data "aws_caller_identity" "current" {}

data "aws_vpc" "cluster_vpc" {
    id                                                  = var.vpc_id
}

resource "aws_kms_key" "automation_library_key" {
    description                                         = "KMS key for encrypting cluster secrets"
    deletion_window_in_days                             = 10
    enable_key_rotation                                 = true
    customer_master_key_spec                            = "SYMMETRIC_DEFAULT"
    key_usage                                           = "ENCRYPT_DECRYPT"
    is_enabled                                          = true
}


resource "aws_security_group" "remote_access_sg" {
    name                                                = "al-cluster-remote-access-sg"
    description                                         = "Bastion host security group"
    vpc_id                                              = var.vpc_id
    tags                                                = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "eks"
                                                        }
}


resource "aws_security_group_rule" "control_plane_ingress" {
    description                                         = "Allow incoming traffic from al-cluster-remote-access-sg to access cluster."
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    security_group_id                                   = aws_eks_cluster.automation_library_cluster.vpc_config[0].cluster_security_group_id
    source_security_group_id                            = aws_security_group.remote_access_sg.id
}


resource "aws_security_group_rule" "remote_access_ingress" {
    description                                         = "Restrict remote access to IP whitelist and VPC CIDR block"
    type                                                = "ingress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    cidr_blocks                                         = concat(
                                                            var.source_ips,
                                                            [
                                                                data.aws_vpc.cluster_vpc.cidr_block
                                                            ]
                                                        )
    security_group_id                                   = aws_security_group.remote_access_sg.id
} 


resource "aws_security_group_rule" "remote_access_egress" {
    description                                         = "Allow outgoing traffic"
    type                                                = "egress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    cidr_blocks                                         = [
                                                            "0.0.0.0/0"
                                                        ]
    security_group_id                                   = aws_security_group.remote_access_sg.id
}


resource "aws_instance" "automation_library_bastion_host" {
    ami                                                 = var.bastion_ami
    associate_public_ip_address                         = true
    # TODO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
    #       use this to generate key-pair instead of doing it manually and passing in the keyname.
    key_name                                            = var.ec2_ssh_key
    instance_type                                       = "t3.nano"
    vpc_security_group_ids                              = [
                                                            aws_security_group.remote_access_sg.id
                                                        ]
    subnet_id                                           = var.public_subnet_ids[0]
    tags                                                = {
                                                            Name = "al-cluster-host"
                                                            Team = "BrightLabs"
                                                            Organization = "AutomationLibrary"
                                                            Service = "ec2"
                                                        }
}


resource "aws_iam_instance_profile" "automation_library_bastion_profile" {
    name                                                = "automation-library-bastion-instance-profile"
    role                                                = var.bastion_role_name
}


resource "aws_eks_cluster" "automation_library_cluster" {
    name                                                = "automation-library-cluster"
    role_arn                                            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.cluster_role_name}"
    enabled_cluster_log_types                           = [
                                                            "api", 
                                                            "audit", 
                                                            "authenticator", 
                                                            "controllerManager", 
                                                            "scheduler"
                                                        ]

    encryption_config {
        resources                                       = [
                                                            "secrets"
                                                        ]

        provider {
            key_arn                                     = aws_kms_key.automation_library_key.arn
        }
    }

    vpc_config {
        subnet_ids                                      = concat(
                                                            var.public_subnet_ids,
                                                            var.private_subnet_ids
                                                        )
        endpoint_private_access                         = true
        endpoint_public_access                          = false
    }

}


resource "aws_eks_node_group" "automation-library-ng" {
    count                                               = var.node_count
    cluster_name                                        = aws_eks_cluster.automation_library_cluster.name
    instance_types                                      = [
                                                            var.instance_type
                                                        ]
    node_group_name                                     = "automation-library-node-group-${count.index}"
    node_role_arn                                       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.node_role_name}"
    subnet_ids                                          = var.private_subnet_ids

    scaling_config {
      desired_size                                      = 2
      max_size                                          = 3
      min_size                                          = 1
    }

    update_config {
      max_unavailable                                   = 1
    }

    remote_access {
        ec2_ssh_key                                     = var.ec2_ssh_key
        source_security_group_ids                       = [
                                                            aws_security_group.remote_access_sg.id
                                                        ]
    }
}


output "endpoint" {
    value                                               = aws_eks_cluster.automation_library_cluster.endpoint
}


output "cluster-sg" {
    value                                               = aws_eks_cluster.automation_library_cluster.vpc_config[0].cluster_security_group_id
}


output "bastion-ip" {
    value                                               = aws_instance.automation_library_bastion_host.public_ip
}


output "bastion-dns"{
    value                                               = aws_instance.automation_library_bastion_host.public_dns
}


output "kubeconfig-certificate-authority-data" {
    value                                               = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}


output "kms-key-arn" {
    value                                               = aws_kms_key.automation_library_key.arn
}


output "kms-key-id" {
    value                                               = aws_kms_key.automation_library_key.id
}