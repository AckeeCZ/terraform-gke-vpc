provider "template" {
  version = "~> 2.1.2"
}

provider "tls" {
  version = "~> 2.2.0"
}

provider "random" {
  version = "~> 2.3.0"
}

provider "vault" {
  version = "~> 2.14.0"
}

provider "google" {
  version = "~> 3.39.0"
}

provider "google-beta" {
  version = "~> 3.39.0"
}

provider "kubernetes" {
  version = "~> 1.13.2"
}

provider "helm" {
  version = "~> 1.3.0"
}

module "gke" {
  source            = "../"
  namespace         = var.namespace
  project           = var.project
  location          = var.zone
  vault_secret_path = var.vault_secret_path
  private           = false
  min_nodes         = 1
  max_nodes         = 2
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
