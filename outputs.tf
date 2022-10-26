output "rds-endpoint" {
    value                                               = module.persistence.rds-endpoint
}


output "elastic-ip" {
    value                                               = module.cluster.elastic-ip
}


output "elastic-dns" {
    value                                               = module.cluster.elastic-dns
}


output "bastion-ip" {
    value                                               = module.cluster.bastion-ip
}


output "bastion-dns" {
    value                                               = module.cluster.bastion-dns
}


output "kubeconfig-certificate-authority-data" {
    value                                               = module.cluster.kubeconfig-certificate-authority-data
}