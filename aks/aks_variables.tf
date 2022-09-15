variable "prefix" {
  description = "Prefix for AKS resource names"
  type        = string

  validation {
    condition     = length(var.prefix) >= 2 && length(var.prefix) <= 45
    error_message = "Error: Prefix is too short or too long. Prefix should have at least 2 and less than 46 characters."
  }
}

variable "rg_name" {
  description = "Name of an resource group to deploy AKS cluster in"
  type        = string
  default     = null
}

variable "vnet_name" {
  description = "Main Virtual Network's name"
  type        = string
  default     = null
}

variable "subnet_name" {
  description = "Name of the existing subnet to deploy AKS cluster in"
  type        = string
  default     = null
}

variable "rsa_pub_path" {
  description = "Public ssh key path"
  type        = string
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "enable_node_public_ip" {
  description = "Whether to enable public IPs or not"
  type        = bool
}

variable "network_plugin" {
  description = "AKS network plugin"
  type        = string
}

variable "network_policy" {
  description = "AKS network policy"
  type        = string
}

variable "enable_rbac" {
  description = "Whether RBAC is enabled or not"
  type        = bool
}

variable "default_node_pool" {
  description = "Default node pool for AKS"
  type = object({
    size         = number
    min          = number
    max          = number
    vm_size      = string
    disk_gb_size = string
    auto_scaling = bool
    type         = string
  })
}

variable "auto_scaler_profile" {
  description = "Auto scaler profile"
  type = object({
    balance_similar_node_groups      = bool
    max_graceful_termination_sec     = string
    scale_down_delay_after_add       = string
    scale_down_delay_after_delete    = string
    scale_down_delay_after_failure   = string
    scan_interval                    = string
    scale_down_unneeded              = string
    scale_down_unready               = string
    scale_down_utilization_threshold = string
  })
}

variable "azure_ad" {
  description = "Azure Active Directory settings"
  type = object({
    managed                = bool
    tenant_id              = string
    admin_group_object_ids = list(string)
  })
}

variable "identity_type" {
  description = "The type of identity used for the managed cluster"
  type        = string
}

variable "admin_username" {
  description = "Admin user on Linux OS"
  type        = string
}
