output "cluster_name" {
  description = "Kubernetes cluster name"
  value       = aws_eks_cluster.eks_cluster.name
}

output "cluster_endpoint" {
  description = "Cluster endpoint"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_token" {
  description = "Cluster auth token"
  value       = data.aws_eks_cluster_auth.eks_auth.token
  sensitive   = true
}

output "cluster_ca" {
  description = "Cluster CA data"
  value       = aws_eks_cluster.eks_cluster.certificate_authority.0.data
}

output "kubeconfig" {
  description = "Kubeconfig as generated from template"
  value       = templatefile("${path.module}/templates/kubeconfig.tpl", {
    endpoint         = aws_eks_cluster.eks_cluster.endpoint
    certificate_data = aws_eks_cluster.eks_cluster.certificate_authority[0].data
    cluster_name     = aws_eks_cluster.eks_cluster.name
  })
  sensitive   = true
}

output "openid_connect_url" {
  description = "OpenId connect provider url"
  value       = aws_iam_openid_connect_provider.eks_openid_connect_provider.url
}

output "openid_connect_arn" {
  description = "OpenId connect provider arn"
  value       = aws_iam_openid_connect_provider.eks_openid_connect_provider.arn
}
