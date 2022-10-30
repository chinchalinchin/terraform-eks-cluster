data "aws_caller_identity" "current" {}


data "aws_vpc" "cluster_vpc" {
    tags                                                = {
                                                            "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
    }   
}