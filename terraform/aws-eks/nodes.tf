resource "aws_iam_role" "eks-nodes-demo" {
  name = "eks-nodes-demo-role"

  assume_role_policy = <<POLICY
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        }
      }
    ]
  }
POLICY
}

resource "aws_iam_role_policy_attachment" "nodes-AWSEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-nodes-demo.name
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-nodes-demo.name 
}

resource "aws_iam_role_policy_attachment" "nodes-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-nodes-demo.name
}

resource "aws_eks_node_group" "private-nodes" {
    cluster_name = aws_eks_cluster.eks-demo.name
    node_group_name = "private-nodes"
    node_role_arn = aws_iam_role.eks-nodes-demo.arn

    subnet_ids = [
        aws_subnet.eks-pv-subnet-1a.id,
        aws_subnet.eks-pv-subnet-1b.id
    ]

    capacity_type = "ON_DEMAND"
    instance_types = [ "t3.small" ]

    scaling_config {
      desired_size = 1
      max_size = 2
      min_size = 1
    }
  update_config {
    max_unavailable = 1
  }

  depends_on = [ 
    aws_iam_role_policy_attachment.nodes-AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.nodes-AWSEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.nodes-AmazonEKS_CNI_Policy

  ]
}
