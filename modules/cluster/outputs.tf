output "bastion-ip" {
    value                                               = aws_eip.bastion_ip.public_ip
}


output "cluster-ip" {
    value                                               = aws_eip.cluster_ip.public_ip
}


output "cluster_endpoint" {
    value                                               = aws_eks_cluster.automation_library_cluster.endpoint
}


output "kubeconfig-certificate-authority-data" {
    value                                               = aws_eks_cluster.automation_library_cluster.certificate_authority[0].data
}


# output "ebs-csi-plugin-arn" {
#     value                                               = aws_eks_addon.ebs_plugin.arn
# }