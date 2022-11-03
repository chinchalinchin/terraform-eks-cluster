locals {
    default_access_cidr                                 = [ 
                                                            "0.0.0.0/0" 
                                                        ]
    ec2_tags                                            = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "ec2"
                                                        }
    eks_logging                                         = [
                                                            "api", 
                                                            "audit", 
                                                            "authenticator", 
                                                            "controllerManager", 
                                                            "scheduler"
                                                        ]
    eks_tags                                            = {
                                                            Organization    = "AutomationLibrary"
                                                            Team            = "BrightLabs"
                                                            Service         = "eks"
                                                        }
    k8s_version                                         = 1.22
}