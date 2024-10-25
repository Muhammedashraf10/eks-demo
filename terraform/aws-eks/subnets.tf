resource "aws_subnet" "eks-pv-subnet-1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.0.0/19"
    availability_zone = "us-east-1a"

    tags = {
      Name = "eks-pv-subnet-1"
    }
  
}

resource "aws_subnet" "eks-pv-subnet-1b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.32.0/19"
    availability_zone = "us-east-1b"

    tags = {
      Name = "eks-pv-subnet-2"
    }
}


resource "aws_subnet" "eks-public-subnet-1a" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.64.0/19"
    availability_zone = "us-east-1a"

    tags = {
      Name = "eks-public-subnet-2"
    }
}

resource "aws_subnet" "eks-public-subnet-1b" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.96.0/19"
    availability_zone = "us-east-1b"

    tags = {
      Name = "eks-public-subnet-2"
    }
}
