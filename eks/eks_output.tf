output "kubeconfig" {
  description = "Kubeconfig as generated from template"
  value       = module.control_plane.kubeconfig
  sensitive   = true
}
