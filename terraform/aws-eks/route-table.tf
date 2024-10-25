resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      nat_gateway_id             = aws_nat_gateway.eks-demo-nat-gateway.id
      gateway_id                 = null
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
      core_network_arn           = null
    }
  ]

  tags = {
    Nane = "RT-PV-EKS"
  }
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route = [
    {
      cidr_block                 = "0.0.0.0/0"
      gateway_id                 = aws_internet_gateway.eks-vpc.id
      carrier_gateway_id         = null
      destination_prefix_list_id = null
      egress_only_gateway_id     = null
      instance_id                = null
      ipv6_cidr_block            = null
      local_gateway_id           = null
      network_interface_id       = null
      transit_gateway_id         = null
      vpc_endpoint_id            = null
      vpc_peering_connection_id  = null
      core_network_arn           = null
      nat_gateway_id             = null
    }
  ]

  tags = {
    Nane = "RT-PBLK-EKS"
  }
}

resource "aws_route_table_association" "private-us-esat-1a" {
  subnet_id      = aws_subnet.eks-pv-subnet-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-esat-1b" {
  subnet_id      = aws_subnet.eks-pv-subnet-1a.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-esat-1a" {
  subnet_id      = aws_subnet.eks-public-subnet-1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public-us-esat-1b" {
  subnet_id      = aws_subnet.eks-public-subnet-1b.id
  route_table_id = aws_route_table.public.id
}
