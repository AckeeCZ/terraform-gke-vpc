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

variable "namespace_labels" {
  description = "Default namespace labels"
  default     = {}
  type        = map(string)
}

variable "machine_type" {
  description = "Default machine type to be used in GKE nodepool"
  default     = "n1-standard-1"
  type        = string
}

variable "sealed_secrets_version" {
  type        = string
  description = "Version of sealed secret helm chart"
  default     = "v1.13.2"
}

variable "enable_sealed_secrets" {
  description = "Create sealed secrets controller"
  default     = true
  type        = bool
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

variable "node_pools" {
  type        = map(any)
  description = "Definition of the node pools, by default uses only ackee_pool"
  default     = {}
}

variable "maintenance_window_time" {
  type        = string
  description = "Time when the maintenance window begins."
  default     = "01:00"
}

variable "initial_node_count" {
  type        = number
  description = "Number of nodes, when cluster starts"
  default     = 1
}

variable "min_master_version" {
  type        = string
  description = "The minimum version of the master"
  default     = null
}

variable "workload_identity_config" {
  type        = bool
  description = "Enable workload identities"
  default     = false
}

variable "use_workload_suggested_oauth_scopes" {
  type        = bool
  description = "In case you follow suggested practise, do not set to false and set scopes directly to workloads. This option is here for migration purpose."
  default     = true
}

variable "monitoring_config_enable_components" {
  type        = list(string)
  description = "The GKE components exposing logs. SYSTEM_COMPONENTS and in beta provider, both SYSTEM_COMPONENTS and WORKLOADS are supported."
  default     = null
}

variable "oauth_scopes" {
  default = [
    "https://www.googleapis.com/auth/devstorage.read_only",
    "https://www.googleapis.com/auth/logging.write",
    "https://www.googleapis.com/auth/monitoring",
    "https://www.googleapis.com/auth/servicecontrol",
    "https://www.googleapis.com/auth/service.management.readonly",
    "https://www.googleapis.com/auth/trace.append",
    "https://www.googleapis.com/auth/compute.readonly",
  ]
  description = "Oauth scopes given to the node pools, further info at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#oauth_scopes, if `workload_identity_config` is set, only `https://www.googleapis.com/auth/cloud-platform` is enabled."
  type        = list(string)
}

variable "istio" {
  type        = bool
  description = "Setup infra for Istio (no installation)"
  default     = false
}

variable "enable_cert_manager" {
  type        = bool
  description = "Enable cert-manager helm chart"
  default     = false
}

variable "cert_manager_version" {
  description = "Version number of helm chart"
  default     = "v1.5.4"
  type        = string
}
