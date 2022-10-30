data "aws_caller_identity" "current" {}


data "aws_vpc" "cluster_vpc" {
    tags                                                = {
                                                            "kubernetes.io/cluster/${var.cluster_name}" = "owned" 
    }   
}


data "aws_subnets" "cluster_public_subnets" {
  tags = {
    "kubernetes.io/role/elb"                            = 1
    Organization                                        = "AutomationLibrary"
    Team                                                = "BrightLabs"
    Service                                             = "vpc"
  } 
}


data "aws_subnets" "cluster_private_subnets" {
   tags = {
      "kubernetes.io/role/interal-elb"                  = 1
      Organization                                      = "AutomationLibrary"
      Team                                              = "BrightLabs"
      Service                                           = "vpc"
    } 
}