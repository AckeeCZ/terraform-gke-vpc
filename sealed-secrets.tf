resource "helm_release" "sealed_secrets" {
  count   = var.enable_sealed_secrets ? 1 : 0
  name    = "sealed-secrets-controller"
  chart   = "sealed-secrets"
  version = var.sealed_secrets_version

  namespace = "kube-system"
  depends_on = [
    google_container_node_pool.ackee_pool
  ]
  repository = "https://bitnami-labs.github.io/sealed-secrets"

}

# https://github.com/bitnami-labs/sealed-secrets/blob/master/docs/GKE.md#private-gke-clusters
resource "google_compute_firewall" "sealed_secrets_allow" {
  name    = "sealed-secrets-allow-master-${var.location}"
  network = var.network
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = [var.private_master_subnet]

  target_tags = ["k8s"]
  count       = var.enable_sealed_secrets && var.private ? 1 : 0
}
