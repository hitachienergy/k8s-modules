# https://docs.aws.amazon.com/eks/latest/userguide/create-node-role.html

resource "aws_iam_role" "eks_nodes_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.nodes_assume_role_policy.json
  name               = "${var.name}-eks-nodes-iam-role"
  description        = "EKS nodes IAM role for cluster ${var.name}"
  tags               = local.tags
}

data "aws_iam_policy_document" "nodes_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["ec2.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_nodes_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_nodes_iam_role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_nodes_iam_role.name
}
