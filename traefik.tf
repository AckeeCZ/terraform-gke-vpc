data "helm_repository" "traefik" {
  name = "traefik"
  url  = "https://containous.github.io/traefik-helm-chart"
}

resource "helm_release" "traefik" {
  count = var.enable_traefik ? 1 : 0

  name    = "traefik"
  chart   = "traefik"
  version = var.traefik_version

  namespace = "kube-system"

  dynamic "set" {
    for_each = var.traefik_custom_values
    content {
      name  = set.value.name
      value = set.value.value
    }
  }

  repository = data.helm_repository.traefik.metadata[0].name

  depends_on = [
    google_container_node_pool.ackee_pool
  ]
}
