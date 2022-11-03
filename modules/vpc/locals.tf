locals {
    private_subnet_cidrs        = [
                                    "10.1.50.0/24",
                                    "10.1.60.0/24"
                                ]
    public_subnet_cidrs          = [
                                    "10.1.10.0/24",
                                    "10.1.20.0/24"
                                ]
    # note: b,c get selected when count = 2.
    availability_zones                                  = {
        0 = "b"
        1 = "c"
    }     
    vpc_cidr                    = "10.1.0.0/16"
    vpc_tags                    = {
                                    Organization    = "AutomationLibrary"
                                    Team            = "BrightLabs"
                                    Service         = "vpc"
                                }
}