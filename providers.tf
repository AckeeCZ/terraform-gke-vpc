provider "random" {
  version = "~> 2.1"
}

provider "vault" {
  version = "~> 2.7.1"
}

provider "google" {
  version = "~> 3.19.0"
}

provider "kubernetes" {
  version = "~> 1.11.0"

  load_config_file = false
  host             = "https://${google_container_cluster.primary.endpoint}"

  username = random_string.cluster_username.result
  password = random_string.cluster_password.result

  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  version = "~> 1.1.1"
  kubernetes {
    load_config_file = false
    host             = "https://${google_container_cluster.primary.endpoint}"

    username = random_string.cluster_username.result
    password = random_string.cluster_password.result

    cluster_ca_certificate = base64decode(google_container_cluster.primary.master_auth.0.cluster_ca_certificate)
  }
}
