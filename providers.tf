provider "random" {
  version = "~> 2.1"
}

provider "vault" {
  version = "~> 2.7.1"
}

provider "google" {
  version = "~> 2.20.0"
}

provider "google-beta" {
  version = "~> 3.6"
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
