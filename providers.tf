provider "random" {
}

provider "vault" {
}

provider "google" {
}

provider "kubernetes" {
  load_config_file = false
  host             = "https://${google_container_cluster.primary.endpoint}"

  username = random_string.cluster_username.result
  password = random_string.cluster_password.result

  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {
    load_config_file = false
    host             = "https://${google_container_cluster.primary.endpoint}"

    username = random_string.cluster_username.result
    password = random_string.cluster_password.result

    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}
