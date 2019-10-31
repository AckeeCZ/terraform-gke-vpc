data "google_container_engine_versions" "current" {
  zone    = "${var.zone}"
  project = "${var.project}"
}

resource "random_string" "cluster_password" {
  length           = 16
  special          = false
}

resource "random_string" "cluster_username" {
  length           = 16
  special          = false
}

data "google_compute_network" "default" {
  project = "${var.project}"
  name    = "default"
}

data "google_container_cluster" "primary" {
  name    = "${var.project}"
  zone    = "${var.zone}"
  project = "${var.project}"
}