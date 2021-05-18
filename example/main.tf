provider "kubernetes" {
  host                   = module.gke.endpoint
  token                  = module.gke.access_token
  cluster_ca_certificate = module.gke.cluster_ca_certificate
}

resource "kubernetes_pod" "nginx" {
  metadata {
    name = "nginx"
    labels = {
      App = "nginx"
    }
  }

  spec {
    container {
      image = "nginx"
      name  = "example"
      port {
        container_port = 80
      }
    }
  }
}

data "google_client_config" "default" {}

module "gke" {
  source                   = "../"
  namespace                = var.namespace
  project                  = var.project
  location                 = var.zone
  vault_secret_path        = var.vault_secret_path
  private                  = false
  min_nodes                = 1
  max_nodes                = 2
  workload_identity_config = false
  node_pools = {
    highcpu : {
      machine_type = "n1-highcpu-2"
      max_nodes    = 1
    }
  }
}

variable "namespace" {
  default = "stage"
}

variable "project" {
}

variable "vault_secret_path" {
}

variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-c"
}
