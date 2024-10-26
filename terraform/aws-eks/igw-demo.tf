resource "aws_internet_gateway" "eks-vpc" {
    vpc_id = aws_vpc.main.id

    tags = {
      Name = "eks-demo-igw"
    }
}
