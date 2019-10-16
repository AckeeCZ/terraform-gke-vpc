output "cluster_username" {
  value = random_string.cluster_username.result
}

output "cluster_password" {
  value = random_string.cluster_password.result
}

output "endpoint" {
  value = google_container_cluster.primary.endpoint
}

output "node_pools" {
  value = google_container_cluster.primary.node_pool
}

output "client_certificate" {
  value = base64encode(
    google_container_cluster.primary.master_auth[0].client_certificate,
  )
}

output "client_key" {
  value = base64encode(google_container_cluster.primary.master_auth[0].client_key)
}

output "cluster_ca_certificate" {
  value = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

output "instance_group_urls" {
  value = google_container_cluster.primary.instance_group_urls
}

output "cluster_ipv4_cidr" {
  value = google_container_cluster.primary.cluster_ipv4_cidr
}

