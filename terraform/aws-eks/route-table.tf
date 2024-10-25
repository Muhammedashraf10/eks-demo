resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  route = [ 
    {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = aws_nat_gateway.eks-demo-nat-gateway.id
        nat_gateway_id = ""
        carrier_gateway_id = ""
        destination_prefix_list_id = ""
        egress_only_gateway_id = ""
        instance_id = ""
        ipv6_cidr_block = ""
        local_gateway_id = ""
        network_interface_id = ""
        transit_gateway_id = ""
        vpc_endpoint_id = ""
        vpc_peering_connection_id = ""
    
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
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.eks-vpc.id
        nat_gateway_id = ""
        carrier_gateway_id = ""
        destination_prefix_list_id = ""
        egress_only_gateway_id = ""
        instance_id = ""
        ipv6_cidr_block = ""
        local_gateway_id = ""
        network_interface_id = ""
        transit_gateway_id = ""
        vpc_endpoint_id = ""
        vpc_peering_connection_id = ""
    }
   ]

   tags = {
     Nane = "RT-PBLK-EKS" 
   }
}

resource "aws_route_table_association" "private-us-esat-1a" {
  subnet_id = aws_subnet.eks-pv-subnet-1a
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private-us-esat-1b" {
  subnet_id = aws_subnet.eks-pv-subnet-1a
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "public-us-esat-1a" {
  subnet_id = aws_subnet.eks-public-subnet-1a
  route_table_id = aws_route_table.public
}

resource "aws_route_table_association" "public-us-esat-1b" {
  subnet_id = aws_subnet.eks-public-subnet-1b
  route_table_id = aws_route_table.public.id
}
