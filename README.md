# Terraform Google Kubernetes Engine VPC-native module

Terraform module for provisioning of GKE cluster with VPC-native nodes and support for private networking (no public IP addresses)

## Private networking

Private GKE cluster creation is divided into few parts:

### Private nodes

Turned on with parameter `private`, all GKE nodes are created without public and thus without route to internet

### Cloud NAT gateway and Cloud Router

Creating GKE cluster with private nodes means they have not internet connection. Creating of NAT GW is no longer part of this module. You can use upstream Google Terraform module like this :

```
resource "google_compute_address" "outgoing_traffic_europe_west3" {
  name    = "nat-external-address-europe-west3"
  region  = var.region
  project = var.project
}

module "cloud-nat" {
  source        = "terraform-google-modules/cloud-nat/google"
  version       = "~> 1.2"
  project_id    = var.project
  region        = var.region
  create_router = true
  network       = "default"
  router        = "nat-router"
  nat_ips       = [google_compute_address.outgoing_traffic_europe_west3.self_link]
}
```

### Private master

This module creates GKE master with private address in subnet specified by parameter `private_master_subnet`. This subnet is then routed to VPC network through VPC peering. Thus every cluster in on VPC network must have unique `private_master_subnet`. Turned on with parameter `private_master`, GKE master gets only private IP address. Setting this to `true` is currently not supported by our toolkit

## Node pools and node counts

This module deletes default GKE node pool and create new pool named `ackee-pool` (name just because of fact, that we are unicorns). This approach is recommended by TF documentation, because then you can change pool parameters (like SA permissions, node count etc.).

Amount of nodes is defined by `min_nodes` and `max_nodes` parameters, which set up autoscaling on node pool. Default values are 1 for both vars, which is effectively not autoscaling, but fits our needs very well :)

## Usage

```hcl
module "gke" {
  source                   = "AckeeCZ/vpc/gke"

  namespace                = var.namespace
  project                  = var.project
  location                 = var.zone
  min_nodes                = 1
  max_nodes                = 2
  private                  = true
  create_nat_gw            = true
  vault_secret_path        = var.vault_secret_path
  vertical_pod_autoscaling = true
  private_master_subnet    = "172.16.0.16/28"
}
```

## Before you do anything in this module

Install pre-commit hooks by running following commands:

```shell script
brew install pre-commit terraform-docs
pre-commit install
```

## Example

Simple example on howto use this module could be found at folder `example`. Use `source spinup_testing.sh` to init
the environment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_container_cluster) | resource |
| [google_compute_firewall.istio_pilot_webhook_allow](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_firewall.sealed_secrets_allow](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_container_node_pool.ackee_pool](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_node_pool) | resource |
| [helm_release.cert_manager](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.sealed_secrets](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.traefik](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_namespace.main](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [vault_generic_secret.default](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |
| [google_compute_network.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/compute_network) | data source |
| [google_container_cluster.primary](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_cluster) | data source |
| [google_container_engine_versions.current](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/container_engine_versions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_auto_repair"></a> [auto\_repair](#input\_auto\_repair) | Allow auto repair of node pool | `bool` | `true` | no |
| <a name="input_auto_upgrade"></a> [auto\_upgrade](#input\_auto\_upgrade) | Allow auto upgrade of node pool | `bool` | `false` | no |
| <a name="input_cert_manager_version"></a> [cert\_manager\_version](#input\_cert\_manager\_version) | Version number of helm chart | `string` | `"v1.5.4"` | no |
| <a name="input_cluster_ipv4_cidr_block"></a> [cluster\_ipv4\_cidr\_block](#input\_cluster\_ipv4\_cidr\_block) | Optional IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of GKE cluster, if not used, var.project is used instead | `string` | `""` | no |
| <a name="input_disk_size_gb"></a> [disk\_size\_gb](#input\_disk\_size\_gb) | Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100GB. | `number` | `100` | no |
| <a name="input_dns_nodelocal_cache"></a> [dns\_nodelocal\_cache](#input\_dns\_nodelocal\_cache) | Enable NodeLocal DNS Cache. This is disruptive operation. All cluster nodes are recreated. | `bool` | `false` | no |
| <a name="input_enable_cert_manager"></a> [enable\_cert\_manager](#input\_enable\_cert\_manager) | Enable cert-manager helm chart | `bool` | `false` | no |
| <a name="input_enable_sealed_secrets"></a> [enable\_sealed\_secrets](#input\_enable\_sealed\_secrets) | Create sealed secrets controller | `bool` | `true` | no |
| <a name="input_enable_traefik"></a> [enable\_traefik](#input\_enable\_traefik) | Enable traefik helm chart for VPC | `bool` | `false` | no |
| <a name="input_initial_node_count"></a> [initial\_node\_count](#input\_initial\_node\_count) | Number of nodes, when cluster starts | `number` | `1` | no |
| <a name="input_istio"></a> [istio](#input\_istio) | Setup infra for Istio (no installation) | `bool` | `false` | no |
| <a name="input_location"></a> [location](#input\_location) | Default GCP zone | `string` | `"europe-west3-c"` | no |
| <a name="input_machine_type"></a> [machine\_type](#input\_machine\_type) | Default machine type to be used in GKE nodepool | `string` | `"n1-standard-1"` | no |
| <a name="input_maintenance_window_time"></a> [maintenance\_window\_time](#input\_maintenance\_window\_time) | Time when the maintenance window begins. | `string` | `"01:00"` | no |
| <a name="input_max_nodes"></a> [max\_nodes](#input\_max\_nodes) | Maximum number of nodes deployed in initial node pool | `number` | `1` | no |
| <a name="input_min_master_version"></a> [min\_master\_version](#input\_min\_master\_version) | The minimum version of the master | `string` | `null` | no |
| <a name="input_min_nodes"></a> [min\_nodes](#input\_min\_nodes) | Minimum number of nodes deployed in initial node pool | `number` | `1` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Default namespace to be created after GKE start | `string` | `"production"` | no |
| <a name="input_namespace_labels"></a> [namespace\_labels](#input\_namespace\_labels) | Default namespace labels | `map(string)` | `{}` | no |
| <a name="input_network"></a> [network](#input\_network) | Name of VPC network we are deploying to | `string` | `"default"` | no |
| <a name="input_node_pools"></a> [node\_pools](#input\_node\_pools) | Definition of the node pools, by default uses only ackee\_pool | `map(any)` | `{}` | no |
| <a name="input_oauth_scopes"></a> [oauth\_scopes](#input\_oauth\_scopes) | Oauth scopes given to the node pools, further info at https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster#oauth_scopes, if `workload_identity_config` is set, only `https://www.googleapis.com/auth/cloud-platform` is enabled. | `list(string)` | <pre>[<br>  "https://www.googleapis.com/auth/devstorage.read_only",<br>  "https://www.googleapis.com/auth/logging.write",<br>  "https://www.googleapis.com/auth/monitoring",<br>  "https://www.googleapis.com/auth/servicecontrol",<br>  "https://www.googleapis.com/auth/service.management.readonly",<br>  "https://www.googleapis.com/auth/trace.append",<br>  "https://www.googleapis.com/auth/compute.readonly"<br>]</pre> | no |
| <a name="input_private"></a> [private](#input\_private) | Flag stating if nodes do not obtain public IP addresses - without turning on create\_nat\_gw parameter, private nodes are not able to reach internet | `bool` | `false` | no |
| <a name="input_private_master"></a> [private\_master](#input\_private\_master) | Flag to put GKE master endpoint ONLY into private subnet. Setting to `false` will create both public and private endpoint. Setting to `true` is currently not supported by Ackee toolkit | `bool` | `false` | no |
| <a name="input_private_master_subnet"></a> [private\_master\_subnet](#input\_private\_master\_subnet) | Subnet for private GKE master. There will be peering routed to VPC created with this subnet. It must be unique within VPC network and must be /28 mask | `string` | `"172.16.0.0/28"` | no |
| <a name="input_project"></a> [project](#input\_project) | GCP project name | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | GCP region | `string` | `"europe-west3"` | no |
| <a name="input_sealed_secrets_version"></a> [sealed\_secrets\_version](#input\_sealed\_secrets\_version) | Version of sealed secret helm chart | `string` | `"v1.13.2"` | no |
| <a name="input_services_ipv4_cidr_block"></a> [services\_ipv4\_cidr\_block](#input\_services\_ipv4\_cidr\_block) | Optional IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. | `string` | `""` | no |
| <a name="input_traefik_custom_values"></a> [traefik\_custom\_values](#input\_traefik\_custom\_values) | Traefik Helm chart custom values list | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "ssl.enabled",<br>    "value": "true"<br>  },<br>  {<br>    "name": "rbac.enabled",<br>    "value": "true"<br>  }<br>]</pre> | no |
| <a name="input_traefik_version"></a> [traefik\_version](#input\_traefik\_version) | Version number of helm chart | `string` | `"1.7.2"` | no |
| <a name="input_upgrade_settings"></a> [upgrade\_settings](#input\_upgrade\_settings) | Upgrade settings for node pool of GKE | `any` | `null` | no |
| <a name="input_vault_secret_path"></a> [vault\_secret\_path](#input\_vault\_secret\_path) | Path to secret in local vault, used mainly to save gke credentials | `string` | n/a | yes |
| <a name="input_vertical_pod_autoscaling"></a> [vertical\_pod\_autoscaling](#input\_vertical\_pod\_autoscaling) | Enable Vertical Pod Autoscaling | `bool` | `false` | no |
| <a name="input_workload_identity_config"></a> [workload\_identity\_config](#input\_workload\_identity\_config) | Enable workload identities | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_access_token"></a> [access\_token](#output\_access\_token) | Client access token used kubeconfig |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | Client certificate used kubeconfig |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | Client key used kubeconfig |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | Client ca used kubeconfig |
| <a name="output_cluster_ipv4_cidr"></a> [cluster\_ipv4\_cidr](#output\_cluster\_ipv4\_cidr) | The IP address range of the Kubernetes pods in this cluster in CIDR notation |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | Cluster control plane endpoint |
| <a name="output_node_pools"></a> [node\_pools](#output\_node\_pools) | List of node pools associated with this cluster |
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
