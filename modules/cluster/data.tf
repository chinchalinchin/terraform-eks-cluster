data "aws_caller_identity" "current" {}

data "aws_vpc" "cluster_vpc" {
    id                                                  = var.vpc_config.id
}

data "tls_certificate" "cluster_oidc_cert" {
  url                                                   = aws_eks_cluster.automation_library_cluster.identity[0].oidc[0].issuer
}