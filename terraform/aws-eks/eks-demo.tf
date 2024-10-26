resource "aws_iam_role" "eks-demo" {
  name = "eks-cluster-demo"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
           "Service": "eks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  }
POLICY
}

resource "aws_iam_role_policy_attachment" "eks-AWSEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks-demo.name
}


resource "aws_eks_cluster" "eks-demo" {
  name     = "demo-cluster"
  role_arn = aws_iam_role.eks-demo.arn

  vpc_config {
    subnet_ids = [
      aws_subnet.eks-public-subnet-1a.id,
      aws_subnet.eks-public-subnet-1b.id,
      aws_subnet.eks-pv-subnet-1a.id,
      aws_subnet.eks-pv-subnet-1b.id
    ]
  }
  depends_on = [aws_iam_role_policy_attachment.eks-AWSEKSWorkerNodePolicy]
}
