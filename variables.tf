variable "location" {
  default = "europe-west3-c"
}

variable "region" {
  default = "europe-west3"
}

variable "project" {
}

variable "namespace" {
  default = "production"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "private" {
  default = false
  type    = bool
}

variable "private_master" {
  default = false
  type    = bool
}

variable "sealed_secrets_version" {
  default = "v1.6.1"
}

variable "tiller_image" {
  default = "gcr.io/kubernetes-helm/tiller:v2.15.1"
}

variable "min_nodes" {
  default = 1
}

variable "max_nodes" {
  default = 1
}

variable "vault_secret_path" {
}

variable "enable_traefik" {
  description = "Enable traefik helm chart for VPC"
  default     = false
  type        = bool
}

variable "traefik_version" {
  description = "Version number of helm chart"
  default     = "1.7.2"
  type        = string
}

variable "auto_repair" {
  default = true
}

variable "auto_upgrade" {
  default = true
}

variable "upgrade_settings" {
  description = "Upgrade settings for node pool of GKE"
  default     = {}
}

variable "traefik_custom_values" {
  description = "Traefik Helm chart custom values list"
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "ssl.enabled"
      value = "true"
    },
    {
      name  = "rbac.enabled"
      value = "true"
    },
  ]
}
