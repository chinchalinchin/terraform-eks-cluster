variable "cluster_name" {
    description                         = "Name to assign to the cluster"
    type                                = string
    default                             = "automation-library-clsuter"
}


variable "region" {
    description                         = "Region where resources are deployed"
    type                               = string
    default                             = "us-east-1"
}