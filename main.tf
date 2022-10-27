module "cluster" {
    source                                  = "./modules/cluster"

    region                                  = var.region
    source_ips                              = var.source_ips
    vpc_config                              = var.vpc_config
    production                              = var.production
    ssh_key                                 = var.ssh_key
    iam_config                              = var.iam_config
    eks_config                              = var.eks_config
    bastion_config                          = var.bastion_config
}

module "persistence" {
    source                                  = "./modules/persistence"

    iam_config                              = var.iam_config
    vpc_config                              = var.vpc_config
}