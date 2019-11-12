resource "kubernetes_service_account" "tiller" {
  automount_service_account_token = true

  metadata {
    name      = "tiller-service-account"
    namespace = "kube-system"
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller-cluster-rule"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller.metadata[0].name
    api_group = ""
    namespace = kubernetes_service_account.tiller.metadata[0].namespace
  }
}

provider "helm" {
  version = "~> 0.10"
  kubernetes {
    load_config_file       = false
    host                   = "https://${google_container_cluster.primary.endpoint}"

    username               = "${random_string.cluster_username.result}"
    password               = "${random_string.cluster_password.result}"

    cluster_ca_certificate = "${base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)}"
  }
  override                 = [
    "spec.template.spec.containers[0].command={/tiller,--storage=secret}"
  ]
  service_account          = "tiller-service-account"
}