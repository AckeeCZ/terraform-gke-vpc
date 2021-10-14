resource "helm_release" "cert_manager" {
  count   = var.enable_cert_manager ? 1 : 0
  name    = "cert-manager"
  chart   = "cert-manager"
  version = var.cert_manager_version

  namespace = "cert-manager"
  depends_on = [
    google_container_node_pool.ackee_pool
  ]
  repository       = "https://charts.jetstack.io"
  create_namespace = true

  set {
    name  = "installCRDs"
    value = "true"
  }

}
