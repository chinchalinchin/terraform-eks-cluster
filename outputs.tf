output "rds-endpoint" {
    value                                               = module.persistence.rds-endpoint
}


output "bastion-ip" {
    value                                               = module.cluster.bastion-ip
}


output "cluster-ip" {
    value                                               = module.cluster.cluster-ip
}


output "kube-api-endpoint"{
    value                                               = module.cluster.cluster_endpoint
}


output "kubeconfig-certificate-authority-data" {
    value                                               = module.cluster.kubeconfig-certificate-authority-data
}

