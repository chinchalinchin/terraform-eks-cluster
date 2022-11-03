output "rds-endpoint" {
    value                                               = module.persistence.rds-endpoint
}


output "ebs-arns" {
    value                                               = module.persistence.ebs-arns
}


output "bastion-ip" {
    value                                               = module.cluster.bastion-ip
}


output "kube-api-endpoint"{
    value                                               = module.cluster.cluster_endpoint
}


output "kubeconfig-certificate-authority-data" {
    value                                               = module.cluster.kubeconfig-certificate-authority-data
}

