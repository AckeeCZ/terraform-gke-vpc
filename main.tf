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

  remove_default_node_pool    = true
  initial_node_count          = var.initial_node_count
  enable_shielded_nodes       = true
  enable_intranode_visibility = true

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

  dynamic "workload_identity_config" {
    for_each = var.workload_identity_config ? [1] : []
    content {
      workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
    }
  }

  dynamic "monitoring_config" {
    for_each = var.monitoring_config_enable_components == null ? [] : [1]
    content {
      enable_components = var.monitoring_config_enable_components
    }
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
    oauth_scopes = var.workload_identity_config && var.use_workload_suggested_oauth_scopes ? [
      "https://www.googleapis.com/auth/cloud-platform",
    ] : lookup(each.value, "oauth_scopes", var.oauth_scopes)

    metadata = {
      disable-legacy-endpoints = "1"
    }

    tags = ["k8s", local.cluster_name]

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

# https://istio.io/latest/docs/setup/platform-setup/gke/
resource "google_compute_firewall" "istio_pilot_webhook_allow" {
  name    = "istio-allow-pilot-webhook-${local.cluster_name}"
  network = var.network
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["15017", "9443"]
  }
  source_ranges = [var.private_master_subnet]

  target_tags = ["k8s", local.cluster_name]
  count       = var.istio && var.private ? 1 : 0
}

resource "kubernetes_cluster_role_binding" "cluster_admin_ci_sa" {
  metadata {
    name = "cluster-admin-gitlab-ci"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = var.ci_sa_email
    api_group = "rbac.authorization.k8s.io"
  }
}
