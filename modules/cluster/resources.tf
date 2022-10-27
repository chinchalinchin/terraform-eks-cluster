# resource "aws_route53_zone" "private_zone" {
#   name                                                  = var.private_domain

#   vpc {
#     vpc_id                                              = var.vpc_config.id
#   }

# }


resource "aws_kms_key" "cluster_key" {
    description                                         = "KMS key for encrypting cluster secrets"
    deletion_window_in_days                             = 10
    enable_key_rotation                                 = true
    customer_master_key_spec                            = "SYMMETRIC_DEFAULT"
    key_usage                                           = "ENCRYPT_DECRYPT"
    is_enabled                                          = true
}


resource "aws_security_group" "remote_access_sg" {
    name                                                = "automation-library-remote-access-sg"
    description                                         = "Bastion host security group"
    vpc_id                                              = var.vpc_config.id
    tags                                                = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "eks"
                                                        }
}


resource "aws_security_group_rule" "control_plane_ingress" {
    description                                         = "Allow incoming traffic from automation-library-remote-access-sg to access cluster."
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
    description                                         = "Allow all outgoing traffic"
    type                                                = "egress"
    from_port                                           = 0
    to_port                                             = 0
    protocol                                            = "-1"
    cidr_blocks                                         = [
                                                            "0.0.0.0/0"
                                                        ]
    security_group_id                                   = aws_security_group.remote_access_sg.id
}


resource "aws_eip" "bastion_ip" {
    vpc                                                 = true
    tags                                                = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "ec2"
                                                        }
}


resource "aws_eip_association" "eip_assoc" {
    instance_id                                         = aws_instance.automation_library_bastion_host.id
    allocation_id                                       = aws_eip.bastion_ip.id
}


resource "aws_route53_record" "bastion_public_record" {
  zone_id                                               = data.aws_route53_zone.public_domain.zone_id
  name                                                  = "bastion.${data.aws_route53_zone.public_domain.name}"
  type                                                  = "A"
  ttl                                                   = 300
  records                                               = [
                                                            aws_eip.bastion_ip.public_ip
                                                        ]
}

resource "aws_instance" "automation_library_bastion_host" {
    ami                                                 = var.bastion_config.ami
    associate_public_ip_address                         = true
    # TODO: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
    #       use this to generate key-pair instead of doing it manually and passing in the keyname.
    key_name                                            = var.ssh_key
    iam_instance_profile                                = var.iam_config.bastion_profile_name
    instance_type                                       = "t3.xlarge"
    user_data                                           = templatefile("${path.root}/scripts/user-data.sh", {
                                                            eks_cluster_name = aws_eks_cluster.automation_library_cluster.name
                                                            aws_default_region = var.region
                                                        })
    vpc_security_group_ids                              = [
                                                            aws_security_group.remote_access_sg.id
                                                        ]
    subnet_id                                           = var.vpc_config.public_subnet_ids[0]
    tags                                                = {
                                                            Name = "automation-library-bastion-host"
                                                            Team = "BrightLabs"
                                                            Organization = "AutomationLibrary"
                                                            Service = "ec2"
                                                        }
}


resource "aws_eip" "cluster_ip" {
    vpc                                                 = true
    tags                                                = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "eks"
                                                        }
}


resource "aws_eks_cluster" "automation_library_cluster" {
    name                                                = "automation-library-cluster"
    role_arn                                            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_config.cluster_role_name}"
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
            key_arn                                     = aws_kms_key.cluster_key.arn
        }
    }

    vpc_config {
        public_access_cidrs                             = !var.production ?  var.source_ips : [ "0.0.0.0/0" ]
        endpoint_private_access                         = true
        endpoint_public_access                          = !var.production
        subnet_ids                                      = concat(
                                                            var.vpc_config.public_subnet_ids,
                                                            var.vpc_config.private_subnet_ids
                                                        )
        security_group_ids                              = [
                                                            aws_security_group.remote_access_sg.id
                                                        ]
    }

}


# resource "aws_iam_openid_connect_provider" "cluster_iam_oidc" {
#   client_id_list                                        = [
#                                                             "sts.amazonaws.com"
#                                                         ]
#   thumbprint_list                                       = data.tls_certificate.cluster_oidc_cert.certificates.*.sha1_fingerprint
#   url                                                   = data.tls_certificate.cluster_oidc_cert.url
# }


# resource "aws_eks_addon" "ebs_plugin" {
#     addon_name                                          = "aws-ebs-csi-driver"
#     addon_version                                       = "v1.11.2-eksbuild.1"
#     cluster_name                                        = aws_eks_cluster.automation_library_cluster.name
#     service_account_role_arn                            = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_config.ebs_role_name}"
#     depends_on                                          = [
#                                                             aws_iam_openid_connect_provider.cluster_iam_oidc
#                                                         ]
# }


resource "aws_eks_node_group" "automation-library-ng" {
    count                                               = var.eks_config.node_count
    cluster_name                                        = aws_eks_cluster.automation_library_cluster.name
    instance_types                                      = [
                                                            var.eks_config.instance_type
                                                        ]
    node_group_name                                     = "automation-library-node-group-${count.index}"
    node_role_arn                                       = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.iam_config.node_role_name}"
    subnet_ids                                          = var.vpc_config.private_subnet_ids

    scaling_config {
      desired_size                                      = 2
      max_size                                          = 3
      min_size                                          = 1
    }

    update_config {
      max_unavailable                                   = 1
    }

    remote_access {
        ec2_ssh_key                                     = var.ssh_key
        source_security_group_ids                       = [
                                                            aws_security_group.remote_access_sg.id,
                                                        ]
    }
}