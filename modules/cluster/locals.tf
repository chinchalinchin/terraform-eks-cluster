locals {
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
}