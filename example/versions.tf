terraform {
  required_version = "1.0.7"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.80.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.80.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 3.1.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 2.22.0"
    }
  }
}
