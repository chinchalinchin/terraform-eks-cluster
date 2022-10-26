output "elastic-ip" {
    value                                               = aws_eip.cluster_ip.public_ip
}


output "elastic-dns" {
    value                                               = aws_eip.cluster_ip.public_dns
}


output "endpoint" {
    value                                               = aws_eks_cluster.automation_library_cluster.endpoint
}


output "cluster-sg" {
    value                                               = aws_eks_cluster.automation_library_cluster.vpc_config[0].cluster_security_group_id
}


output "bastion-ip" {
    value                                               = aws_instance.automation_library_bastion_host.public_ip
    # value                                               = var.production ? aws_instance.automation_library_bastion_host[0].public_ip : null
}


output "bastion-dns"{
    value                                               = aws_instance.automation_library_bastion_host.public_dns
    # value                                               = var.production ? aws_instance.automation_library_bastion_host[0].public_dns : null
}


output "kubeconfig-certificate-authority-data" {
    value                                               = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}


output "kms-key-arn" {
    value                                               = aws_kms_key.cluster_key.arn
}


output "kms-key-id" {
    value                                               = aws_kms_key.cluster_key.id
}


# output "ebs-csi-plugin-arn" {
#     value                                               = aws_eks_addon.ebs_plugin.arn
# }