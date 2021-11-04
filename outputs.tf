output "endpoint" {
  description = "Cluster control plane endpoint"
  value       = google_container_cluster.primary.endpoint
}

output "node_pools" {
  description = "List of node pools associated with this cluster"
  value       = google_container_cluster.primary.node_pool
}

output "client_certificate" {
  description = "Client certificate used kubeconfig"
  value       = base64decode(google_container_cluster.primary.master_auth[0].client_certificate)
}

output "client_key" {
  description = "Client key used kubeconfig"
  value       = base64decode(google_container_cluster.primary.master_auth[0].client_key)
}

output "cluster_ca_certificate" {
  description = "Client ca used kubeconfig"
  value       = base64decode(google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

output "access_token" {
  description = "Client access token used kubeconfig"
  value       = data.google_client_config.default.access_token
}

output "cluster_ipv4_cidr" {
  description = "The IP address range of the Kubernetes pods in this cluster in CIDR notation"
  value       = google_container_cluster.primary.cluster_ipv4_cidr
}
