resource "google_service_account" "default" {
  account_id   = substr("default-gke-${replace(local.cluster_name, "_", "-")}", 0, 28)
  display_name = substr("default-gke-${replace(local.cluster_name, "_", "-")}", 0, 28)
}
