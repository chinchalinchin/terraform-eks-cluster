
# adapted from cloudformation template: https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml


resource "aws_vpc" "automation_library_vpc" {
    cidr_block                                  = local.vpc_cidr
    enable_dns_hostnames                        = true
    enable_dns_support                          = true
    enable_network_address_usage_metrics        = true
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                                      = "automation-library-vpc"
                                                        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
                                                    }
                                                )
}


resource "aws_internet_gateway" "automation_library_internet_gateway" {
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                                      = "automation-library-internet-gateway"
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id
}


resource "aws_eip" "nat_ip" {
    for_each                                    = toset(local.availability_zones)

    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                                  = "automation-library-nat-ip-${each.key}"
                                                    }
                                                )
    vpc                                         = true
}


resource "aws_nat_gateway" "automation_library_nat_gateway" {
    for_each                                    = toset(local.availability_zones)

    depends_on                                  = [
                                                    aws_internet_gateway.automation_library_internet_gateway
                                                ]
    allocation_id                               = aws_eip.nat_ip.*.id[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ]
    subnet_id                                   = aws_subnet.automation_library_public_subnet[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ].id
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                                  = "automation-library-nat-gateway-${count.index}"
                                                    }
                                                )

}


# see: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#network-requirements-subnets
resource "aws_subnet" "automation_library_private_subnet" {
    for_each                                    = toset(local.availability_zones)

    availability_zone                           = format("%s%s",
                                                    var.region,
                                                    local.availability_zones[
                                                        index(
                                                            toset(local.availability_zones), 
                                                            each.value
                                                        )
                                                    ]
                                                )
    cidr_block                                  = local.private_subnet_cidrs[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ]
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                            = "automation-library-private-subnet-${each.value}"
                                                        "kubernetes.io/role/internal-elb" = 1
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id
}

# see: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#network-requirements-subnets
resource "aws_subnet"   "automation_library_public_subnet" {
    for_each                                    = toset(local.availability_zones)
    
    availability_zone                           = format("%s%s",
                                                    var.region,
                                                    local.availability_zones[
                                                        index(
                                                            toset(local.availability_zones), 
                                                            each.value
                                                        )
                                                    ]
                                                )
    

    cidr_block                                  = local.public_subnet_cidrs[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ]
    map_public_ip_on_launch                     = true
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                      = "automation-library-public-subnet-${each.key}"
                                                        "kubernetes.io/role/elb"    = 1
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id
}


resource "aws_route_table" "automation_library_public_route_table" {
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                      = "automation-library-public-route-table"
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id

    route {
        cidr_block                              = "0.0.0.0/0"
        gateway_id                              = aws_internet_gateway.automation_library_internet_gateway.id
    }

}


resource "aws_route_table_association" "automation_library_public_route_table_association" {
    for_each                                    = toset(local.availability_zones)

    subnet_id                                   = aws_subnet.automation_library_public_subnet[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ].id
    route_table_id                              = aws_route_table.automation_library_public_route_table.id
}


resource "aws_route_table" "automation_library_private_route_table" {
    for_each                                    = toset(local.availability_zones)

    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "Name"                  = "automation-library-private-route-table-${each.key}"
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id

    route {
        cidr_block                              = "0.0.0.0/0"
        gateway_id                              = aws_nat_gateway.automation_library_nat_gateway[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ].id
    }
}


resource "aws_route_table_association" "automation_library_private_route_table_association" {
    for_each                                    = toset(local.availability_zones)
    subnet_id                                   = aws_subnet.automation_library_private_subnet[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ].id
    route_table_id                              = aws_route_table.automation_library_private_route_table[
                                                    index(
                                                        toset(local.availability_zones), 
                                                        each.value
                                                    )
                                                ].id
}