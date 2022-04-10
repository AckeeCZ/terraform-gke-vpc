# resource "vault_generic_secret" "default" {
#   path = "${var.vault_secret_path}/gke/${var.location}/${local.cluster_name}-credentials"
#   data_json = jsonencode(
#     {
#       client_certificate     = google_container_cluster.primary.master_auth[0].client_certificate
#       client_key             = google_container_cluster.primary.master_auth[0].client_key
#       cluster_ca_certificate = google_container_cluster.primary.master_auth[0].cluster_ca_certificate
#     }
#   )
# }
