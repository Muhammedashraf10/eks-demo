resource "aws_eip" "eks-demo-gateway-eip" {
    vpc = true
    tags = {
      "Name" = "NAT gateway"
    }
}

resource "aws_nat_gateway" "eks-demo-nat-gateway" {
  allocation_id = aws_eip.eks-demo-gateway-eip.id
  subnet_id = aws_subnet.eks-public-subnet-1a


  tags = {
    "Name" = "Nat-GW-eks-demo" 
  }
}