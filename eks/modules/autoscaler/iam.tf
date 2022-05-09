# https://docs.aws.amazon.com/eks/latest/userguide/iam-roles-for-service-accounts.html
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster#enabling-iam-roles-for-service-accounts

data "aws_iam_policy_document" "autoscaler_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(var.openid_connect_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:${local.k8s_service_account_namespace}:${local.k8s_service_account_name}"]
    }

    principals {
      identifiers = [var.openid_connect_arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  assume_role_policy = data.aws_iam_policy_document.autoscaler_assume_role_policy.json
  name               = "${var.name}-cluster-autoscaler"
  description        = "EKS cluster-autoscaler IAM role for cluster ${var.name}"
  tags               = local.tags
}

# https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-ng-considerations
data "aws_iam_policy_document" "cluster_autoscaler" {
  statement {
    actions   = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]
    effect    = "Allow"
    resources = ["*"]
  }
}

resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "${var.name}-cluster-autoscaler"
  description = "EKS cluster-autoscaler IAM policy for cluster ${var.name}"
  policy      = data.aws_iam_policy_document.cluster_autoscaler.json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
  role       = aws_iam_role.cluster_autoscaler.name
}
