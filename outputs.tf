output "cluster_username" {
  description = "Cluster master username, keep always secret!"
  value       = random_string.cluster_username.result
}

output "cluster_password" {
  description = "Cluster master password, keep always secret!"
  value       = random_string.cluster_password.result
}

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
  value = base64encode(
    google_container_cluster.primary.master_auth[0].client_certificate,
  )
}

output "client_key" {
  description = "Client key used kubeconfig"
  value       = base64encode(google_container_cluster.primary.master_auth[0].client_key)
}

output "cluster_ca_certificate" {
  description = "Client ca used kubeconfig"
  value = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

output "instance_group_urls" {
  description = "List of instance group URLs which have been assigned to the cluster"
  value       = google_container_cluster.primary.instance_group_urls
}

output "cluster_ipv4_cidr" {
  description = "The IP address range of the Kubernetes pods in this cluster in CIDR notation"
  value       = google_container_cluster.primary.cluster_ipv4_cidr
}

