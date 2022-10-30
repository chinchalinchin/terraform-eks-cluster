
# adapted from cloudformation template: https://s3.us-west-2.amazonaws.com/amazon-eks/cloudformation/2020-10-29/amazon-eks-vpc-private-subnets.yaml


resource "aws_vpc" "automation_library_vpc" {
    cidr_block                                  = local.vpc_cidr
    enable_dns_hostnames                        = true
    enable_dns_support                          = true
    enable_network_address_usage_metrics        = true
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                    
                                                        "kubernetes.io/cluster/${var.cluster_name}" = "owned"
                                                    }
                                                )
}


resource "aws_internet_gateway" "automation_library_internet_gateway" {
    tags                                        = local.vpc_tags
    vpc_id                                      = aws_vpc.automation_library_vpc.id
}


resource "aws_eip" "nat_ip" {
    count                                               = 2

    tags                                                = local.vpc_tags
    vpc                                                 = true
}


resource "aws_nat_gateway" "automation_library_nat_gateway" {
    count                                       = 2
    depends_on                                  = [
                                                    aws_internet_gateway.automation_library_internet_gateway
                                                ]
    allocation_id                               = aws_eip.nat_ip.*.id[count.index]
    subnet_id                                   = aws_subnet.automation_library_private_subnet.*.id[count.index]
    tags                                        = local.vpc_tags

}


# see: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#network-requirements-subnets
resource "aws_subnet" "automation_library_private_subnet" {
    count                                       = 2

    availability_zone                           = local.availability_zones[count.index]
    cidr_block                                  = local.private_subnet_cidrs[count.index]
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "kubernetes.io/role/internal-elb" = 1
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id
}

# see: https://docs.aws.amazon.com/eks/latest/userguide/network_reqs.html#network-requirements-subnets
resource "aws_subnet"   "automation_library_public_subnet" {
    count                                       = 2
    
    availability_zone                           = local.availability_zones[count.index]
    cidr_block                                  = local.public_subnet_cidrs[count.index]
    map_public_ip_on_launch                     = true
    tags                                        = merge(
                                                    local.vpc_tags,
                                                    {
                                                        "kubernetes.io/role/elb"    = 1
                                                    }
                                                )
    vpc_id                                      = aws_vpc.automation_library_vpc.id
}


resource "aws_route_table" "automation_library_public_route_table" {

    tags                                        = local.vpc_tags
    vpc_id                                      = aws_vpc.automation_library_vpc.id

    route {
        cidr_block                              = "0.0.0.0/0"
        gateway_id                              = aws_internet_gateway.automation_library_internet_gateway.id
    }

}


resource "aws_route_table_association" "automation_library_public_route_table_association" {
    count                                       = 2

    subnet_id                                   = aws_subnet.automation_library_public_subnet[count.index].id
    route_table_id                              = aws_route_table.automation_library_public_route_table.id
}


resource "aws_route_table" "automation_library_private_route_table" {
    count                                       = 2

    tags                                        = local.vpc_tags
    vpc_id                                      = aws_vpc.automation_library_vpc.id

    route {
        cidr_block                              = "0.0.0.0/0"
        gateway_id                              = aws_nat_gateway.automation_library_nat_gateway.*.id[count.index]
    }
}


resource "aws_route_table_association" "automation_library_private_route_table_association" {
    count                                       = 2
    subnet_id                                   = aws_subnet.automation_library_private_subnet[count.index].id
    route_table_id                              = aws_route_table.automation_library_private_route_table[count.index].id
}