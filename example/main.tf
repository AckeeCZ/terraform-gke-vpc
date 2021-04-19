provider "template" {
  version = "~> 2.2.0"
}

provider "tls" {
  version = "~> 3.1.0"
}

provider "random" {
  version = "~> 3.1.0"
}

provider "vault" {
  version = "~> 2.19.0"
}

provider "google" {
  version = "~> 3.64.0"
}

provider "google-beta" {
  version = "~> 3.64.0"
}

provider "kubernetes" {
  version                = "~> 2.1.0"
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
  source            = "../"
  namespace         = var.namespace
  project           = var.project
  location          = var.zone
  vault_secret_path = var.vault_secret_path
  private           = false
  min_nodes         = 1
  max_nodes         = 2

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
