variable "name" {
  description = "Prefix for resource names and tags"
  type        = string
}

variable "region" {
  description = "Region for AWS resources"
  type        = string
}

# The cluster autoscaler major and minor versions must match your cluster.
# For example if you are running a 1.16 EKS cluster set version to v1.16.5
# See https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/docs/autoscaling.md#notes
variable "autoscaler_version" {
  description = "EKS autoscaler image tag"
  type        = string
}

variable "autoscaler_chart_version" {
  description = "EKS chart version"
  type        = string
}

variable "openid_connect_url" {
  description = "OpenId connect provider url"
  type        = string
}

variable "openid_connect_arn" {
  description = "OpenId connect provider arn"
  type        = string
}

# https://github.com/kubernetes/autoscaler/blob/master/cluster-autoscaler/FAQ.md#how-does-scale-down-work
variable "autoscaler_scale_down_utilization_threshold" {
  description = "Autoscaler scale down utilization threshold"
  type        = string
}
