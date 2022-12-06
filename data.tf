data "google_container_engine_versions" "current" {
  location = var.location
  project  = var.project
}

data "google_client_config" "default" {
}

data "google_compute_network" "default" {
  project = var.project
  name    = var.network
}

data "google_project" "project" {
}
