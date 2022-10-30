
module "cluster" {
    source                                  = "./modules/cluster"

    cluster_name                            = var.cluster_name
    bastion_config                          = var.bastion_config
    eks_config                              = var.eks_config
    iam_config                              = var.iam_config
    public_domain                           = var.public_domain
    private_domain                          = var.private_domain
    region                                  = var.region
    source_ips                              = var.source_ips
    ssh_key                                 = var.ssh_key

}


module "persistence" {
    source                                  = "./modules/persistence"

    iam_config                              = var.iam_config
}


module "vpc" {
    source                                  = "./modules/vpc"

    cluster_name                            = var.cluster_name

}
