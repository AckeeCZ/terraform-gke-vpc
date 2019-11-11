provider "random" {
  version = "~> 2.1"
}

provider "google" {
  version = "~> 2.17.0"
}

resource "google_container_cluster" "primary" {
  name               = var.project
  location           = var.location
  project            = var.project
  min_master_version = data.google_container_engine_versions.current.latest_master_version

  initial_node_count = 1

  master_auth {
    username = random_string.cluster_username.result
    password = random_string.cluster_password.result

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  network                 = data.google_compute_network.default.self_link
  enable_kubernetes_alpha = "false"
  logging_service         = "logging.googleapis.com/kubernetes"
  monitoring_service      = "monitoring.googleapis.com/kubernetes"

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
    ]

    metadata = {
      disable-legacy-endpoints = "1"
    }

    tags = ["k8s"]
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = false
  }

  ip_allocation_policy {
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "world"
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = "01:00"
    }
  }
}

resource "google_compute_router" "router" {
  name    = "router01"
  region  = var.region
  project = var.project
  network = data.google_compute_network.default.self_link
}

resource "google_compute_address" "outgoing-traffic" {
  count   = 1
  name    = "nat-external-address-eu"
  region  = var.region
  project = var.project
}

resource "google_compute_router_nat" "advanced-nat" {
  name                               = "nat01"
  router                             = google_compute_router.router.name
  region                             = var.region
  project                            = var.project
  nat_ip_allocate_option             = "MANUAL_ONLY"
  nat_ips                            = [google_compute_address.outgoing-traffic[0].self_link]
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

provider "kubernetes" {
  version = "1.9.0"

  load_config_file = false
  host             = "https://${google_container_cluster.primary.endpoint}"

  username = random_string.cluster_username.result
  password = random_string.cluster_password.result

  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

resource "kubernetes_namespace" "main" {
  metadata {
    name = var.namespace
  }
}
