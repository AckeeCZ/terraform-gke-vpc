terraform {
  required_version = "1.3.6"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.45.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.45.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.16.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.4.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 3.14.0"
    }
  }
}
