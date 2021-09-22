locals {
  node_pools = merge({
    ackee-pool : {}
  }, var.node_pools)
  cluster_name = var.cluster_name == "" ? var.project : var.cluster_name
}

resource "google_container_cluster" "primary" {
  provider           = google-beta
  name               = local.cluster_name
  location           = var.location
  project            = var.project
  min_master_version = var.min_master_version == null ? data.google_container_engine_versions.current.latest_master_version : var.min_master_version

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
  enable_shielded_nodes    = true

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  network                 = data.google_compute_network.default.self_link
  enable_kubernetes_alpha = "false"
  logging_service         = "logging.googleapis.com/kubernetes"
  monitoring_service      = "monitoring.googleapis.com/kubernetes"

  private_cluster_config {
    enable_private_endpoint = var.private_master
    enable_private_nodes    = var.private
    master_ipv4_cidr_block  = var.private ? var.private_master_subnet : null
  }

  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.cluster_ipv4_cidr_block
    services_ipv4_cidr_block = var.services_ipv4_cidr_block
  }

  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "0.0.0.0/0"
      display_name = "world"
    }
  }

  maintenance_policy {
    daily_maintenance_window {
      start_time = var.maintenance_window_time
    }
  }
  vertical_pod_autoscaling {
    enabled = var.vertical_pod_autoscaling
  }
  addons_config {
    dns_cache_config {
      enabled = var.dns_nodelocal_cache
    }
  }
}

resource "google_container_node_pool" "ackee_pool" {
  for_each = local.node_pools

  name     = each.key
  project  = var.project
  location = var.location
  cluster  = google_container_cluster.primary.name

  initial_node_count = var.initial_node_count

  node_locations = lookup(each.value, "node_locations", null)

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  autoscaling {
    max_node_count = lookup(each.value, "max_nodes", var.max_nodes)
    min_node_count = lookup(each.value, "min_nodes", var.min_nodes)
  }

  dynamic "upgrade_settings" {
    # a black magic to create block only if upgrade_settings contains any value
    for_each = var.upgrade_settings == null ? [] : [1]
    content {
      max_surge       = lookup(var.upgrade_settings, "max_surge", 1)
      max_unavailable = lookup(var.upgrade_settings, "max_unavailable", 1)
    }
  }

  node_config {
    oauth_scopes = [
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/servicecontrol",
      "https://www.googleapis.com/auth/service.management.readonly",
      "https://www.googleapis.com/auth/trace.append",
      "https://www.googleapis.com/auth/compute.readonly"
    ]

    metadata = {
      disable-legacy-endpoints = "1"
    }

    tags = ["k8s"]

    preemptible  = false
    machine_type = lookup(each.value, "machine_type", var.machine_type)
    disk_size_gb = lookup(each.value, "disk_size_gb", var.disk_size_gb)
  }
}

resource "kubernetes_namespace" "main" {
  metadata {
    name   = var.namespace
    labels = var.namespace_labels
  }
}
