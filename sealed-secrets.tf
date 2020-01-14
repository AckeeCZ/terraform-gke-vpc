resource "helm_release" "sealed_secrets" {
  name    = "sealed-secrets-controller"
  chart   = "stable/sealed-secrets"
  version = var.sealed_secrets_version

  namespace  = "kube-system"
  depends_on = [google_container_node_pool.ackee_pool]

}

# https://github.com/bitnami-labs/sealed-secrets/blob/master/docs/GKE.md#private-gke-clusters
resource "google_compute_firewall" "sealed_secrets_allow" {
  name    = "sealed-secrets-allow-master"
  network = "default"
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }
  source_ranges = ["172.16.0.0/28"]

  target_tags = ["k8s"]
  count       = var.private ? 1 : 0
}
