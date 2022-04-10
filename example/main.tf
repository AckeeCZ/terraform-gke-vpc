resource "google_compute_address" "outgoing_traffic_europe_west_3" {
  name    = "nat-external-address-${var.region}"
  region  = var.region
  project = var.project
}

module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 2.1.0"
  project_id    = var.project
  region        = var.region
  create_router = true
  network       = "default"
  router        = "nat-router"
  nat_ips       = [google_compute_address.outgoing_traffic_europe_west_3.self_link]
}

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
  private                  = true
  min_nodes                = 1
  max_nodes                = 2
  workload_identity_config = true
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

# variable "vault_secret_path" {
# }

variable "region" {
  default = "europe-west3"
}

variable "zone" {
  default = "europe-west3-c"
}
