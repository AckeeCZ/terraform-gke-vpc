resource "google_compute_address" "outgoing_traffic_europe_west_3" {
  name    = "nat-external-address-${var.region}"
  region  = var.region
  project = var.project
}

module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 2.2.0"
  project_id    = var.project
  region        = var.region
  create_router = true
  network       = "default"
  router        = "nat-router"
  nat_ips       = [google_compute_address.outgoing_traffic_europe_west_3.self_link]
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
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
  source                              = "../"
  namespace                           = var.namespace
  project                             = var.project
  location                            = var.region
  vault_secret_path                   = var.vault_secret_path
  enable_sealed_secrets               = false
  private                             = true
  min_nodes                           = 1
  max_nodes                           = 2
  workload_identity_config            = true
  use_workload_suggested_oauth_scopes = false
  node_pools = {
    highcpu : {
      machine_type = "n1-highcpu-2"
      max_nodes    = 1
    }
  }
  cluster_admins = [
    "martin.beranek@ackee.cz",
    "ondrej.storc@ackee.cz",
    "tomas.hejatko@ackee.cz",
  ]
  monitoring_config_enable_components = [
    "SYSTEM_COMPONENTS"
  ]
  enable_autopilot         = true
  vertical_pod_autoscaling = true
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
