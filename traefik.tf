resource "helm_release" "traefik" {
  count = var.enable_traefik ? 1 : 0

  name    = "traefik"
  chart   = "traefik"
  version = var.traefik_version

  namespace        = var.traefik_namespace
  create_namespace = true

  dynamic "set" {
    for_each = var.traefik_custom_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  repository = "https://helm.traefik.io/traefik"

  depends_on = [
    google_container_node_pool.ackee_pool
  ]
}
