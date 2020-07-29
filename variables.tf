variable "location" {
  description = "Default GCP zone"
  default     = "europe-west3-c"
  type        = string
}

variable "region" {
  description = "GCP region"
  default     = "europe-west3"
  type        = string
}

variable "project" {
  description = "GCP project name"
  type        = string
}

variable "cluster_name" {
  description = "Name of GKE cluster, if not used, var.project is used instead"
  default     = ""
  type        = string
}

variable "namespace" {
  description = "Default namespace to be created after GKE start"
  default     = "production"
  type        = string
}

variable "machine_type" {
  description = "Default machine type to be used in GKE nodepool"
  default     = "n1-standard-1"
  type        = string
}

variable "sealed_secrets_version" {
  type        = string
  description = "Version of sealed secret helm chart"
  default     = "v1.6.1"
}

variable "min_nodes" {
  description = "Minimum number of nodes deployed in initial node pool"
  default     = 1
  type        = number
}

variable "max_nodes" {
  description = "Maximum number of nodes deployed in initial node pool"
  default     = 1
  type        = number
}

variable "vault_secret_path" {
  description = "Path to secret in local vault, used mainly to save gke credentials"
  type        = string
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
  description = "Allow auto repair of node pool"
  default     = true
  type        = bool
}

variable "auto_upgrade" {
  description = "Allow auto upgrade of node pool"
  default     = false
  type        = bool
}

variable "upgrade_settings" {
  description = "Upgrade settings for node pool of GKE"
  default     = null
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

variable "network" {
  type        = string
  description = "Name of VPC network we are deploying to"
  default     = "default"
}

variable "private_master" {
  description = "Flag to put GKE master endpoint ONLY into private subnet. Setting to `false` will create both public and private endpoint. Setting to `true` is currently not supported by Ackee toolkit"
  default     = false
  type        = bool
}

variable "private_master_subnet" {
  description = "Subnet for private GKE master. There will be peering routed to VPC created with this subnet. It must be unique within VPC network and must be /28 mask"
  default     = "172.16.0.0/28"
  type        = string
}

variable "private" {
  description = "Flag stating if nodes do not obtain public IP addresses - without turning on create_nat_gw parameter, private nodes are not able to reach internet"
  default     = false
  type        = bool
}

variable "cluster_ipv4_cidr_block" {
  type        = string
  description = "Optional IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size."
  default     = ""
}

variable "services_ipv4_cidr_block" {
  type        = string
  description = "Optional IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size."
  default     = ""
}

variable "vertical_pod_autoscaling" {
  description = "Enable Vertical Pod Autoscaling"
  default     = false
  type        = bool
}

variable "disk_size_gb" {
  description = "Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100GB."
  default     = 100
  type        = number
}

variable "dns_nodelocal_cache" {
  type        = bool
  description = "Enable NodeLocal DNS Cache. This is disruptive operation. All cluster nodes are recreated."
  default     = false
}
