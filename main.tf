locals {
  node_pools = merge({
    "${var.ackee_pool_name}" : {}
  }, var.node_pools)
  cluster_name = var.cluster_name == "" ? var.project : var.cluster_name
  mesh_apis = var.anthos ? [
    "mesh.googleapis.com",
    "meshca.googleapis.com",
    "meshtelemetry.googleapis.com",
    "meshconfig.googleapis.com",
    "gkeconnect.googleapis.com",
    "gkehub.googleapis.com"
  ] : []
  cluster_admins     = concat(["${var.ci_sa_email}"], var.cluster_admins)
  auto_upgrade       = (var.auto_upgrade == true || var.release_channel == "REGULAR") ? true : false
  auto_repair        = (var.auto_repair == true || var.release_channel == "REGULAR") ? true : false
  min_master_version = (var.min_master_version == null && var.release_channel == null) ? data.google_container_engine_versions.current.latest_master_version : (var.min_master_version == null ? data.google_container_engine_versions.current.release_channel_default_version[var.release_channel] : var.min_master_version)
}

resource "google_container_cluster" "primary" {
  provider           = google-beta
  name               = local.cluster_name
  location           = var.location
  project            = var.project
  min_master_version = local.min_master_version

  dynamic "release_channel" {
    for_each = var.release_channel == null ? [] : [1]
    content {
      channel = var.release_channel
    }
  }

  dynamic "network_policy" {
    for_each = var.network_policy == null ? [] : [1]
    content {
      enabled  = true
      provider = var.network_policy
    }
  }

  remove_default_node_pool = true
  initial_node_count       = var.initial_node_count
  enable_shielded_nodes    = true
  resource_labels          = var.cluster_labels

  master_auth {
    client_certificate_config {
      issue_client_certificate = true
    }
  }

  network                 = data.google_compute_network.default.self_link
  enable_kubernetes_alpha = "false"

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
      dynamic "managed_prometheus" {
        for_each = var.managed_prometheus_enable == false ? [] : [1]
        content {
          enabled = var.managed_prometheus_enable
        }
      }
    }
  }



  addons_config {
    dns_cache_config {
      enabled = var.dns_nodelocal_cache
    }
    dynamic "network_policy_config" {
      for_each = var.network_policy == null ? [] : [1]
      content {
        disabled = false
      }
    }
  }

  depends_on = [
    google_project_service.anthos_api,
    google_project_service.mesh_apis
  ]
}

resource "google_container_node_pool" "ackee_pool" {
  for_each = local.node_pools

  name     = each.key
  project  = var.project
  location = var.location
  cluster  = google_container_cluster.primary.name

  initial_node_count = var.initial_node_count

  lifecycle {
    ignore_changes = [
      initial_node_count
    ]
  }

  node_locations = lookup(each.value, "node_locations", null)

  management {
    auto_repair  = local.auto_repair
    auto_upgrade = local.auto_upgrade
  }

  autoscaling {
    max_node_count  = lookup(each.value, "max_nodes", var.max_nodes)
    min_node_count  = lookup(each.value, "min_nodes", var.min_nodes)
    location_policy = lookup(each.value, "node_pool_location_policy", var.node_pool_location_policy)
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

    dynamic "gcfs_config" {
      for_each = var.image_streaming ? [1] : []
      content {
        enabled = true
      }
    }

    dynamic "workload_metadata_config" {
      for_each = var.workload_identity_config ? [1] : []
      content {
        mode = "GKE_METADATA"
      }
    }

    tags = ["k8s"]

    preemptible  = lookup(each.value, "preemptible", false)
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

resource "google_project_service" "containerfilesystem_api" {
  service                    = "containerfilesystem.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
  project                    = var.project
  count                      = var.image_streaming ? 1 : 0
}

# https://cloud.google.com/service-mesh/docs/private-cluster-open-port
resource "google_compute_firewall" "istio_pilot_webhook_allow" {
  name    = "istio-allow-pilot-webhook-${local.cluster_name}"
  network = var.network
  project = var.project

  allow {
    protocol = "tcp"
    ports    = ["15014", "15017", "9443", "10250"]
  }
  source_ranges = [var.private_master_subnet]

  target_tags = ["k8s", local.cluster_name]
  count       = var.anthos && var.private ? 1 : 0
}

resource "kubernetes_cluster_role_binding" "cluster_admin_ci_sa" {
  for_each = toset(local.cluster_admins)
  metadata {
    name = "cluster-admin-${each.key}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "User"
    name      = each.value
    api_group = "rbac.authorization.k8s.io"
  }
}

resource "google_project_service" "mesh_apis" {
  for_each                   = toset(local.mesh_apis)
  service                    = each.value
  disable_dependent_services = false
  disable_on_destroy         = false
  project                    = var.project
}

resource "google_project_service" "anthos_api" {
  service                    = "anthos.googleapis.com"
  disable_dependent_services = false
  disable_on_destroy         = true
  project                    = var.project
  count                      = var.anthos ? 1 : 0
}

resource "google_gke_hub_membership" "anthos" {
  provider      = google-beta
  project       = var.project
  membership_id = local.cluster_name
  endpoint {
    gke_cluster {
      resource_link = google_container_cluster.primary.id
    }
  }
  authority {
    issuer = "https://container.googleapis.com/v1/${google_container_cluster.primary.id}"
  }
  count = var.anthos ? 1 : 0
}

resource "google_gke_hub_feature" "anthos" {
  provider = google-beta

  name     = "servicemesh"
  location = "global"
  count    = var.anthos ? 1 : 0
}
