# https://docs.aws.amazon.com/eks/latest/userguide/service_IAM_role.html

resource "aws_iam_role" "eks_cluster_iam_role" {
  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role_policy.json
  name               = "${var.name}-eks-cluster-iam-role"
  description        = "EKS cluster IAM role for cluster ${var.name}"
  tags               = local.tags
}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = ["eks.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_iam_cluster_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_iam_role.name
}

# Enable security groups for pods
# Reference: https://docs.aws.amazon.com/eks/latest/userguide/security-groups-for-pods.html
resource "aws_iam_role_policy_attachment" "eks_iam_vpc_resource_controller_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster_iam_role.name
}
