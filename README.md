# Terraform Google Kubernetes Engine VPC-native module

Terraform module for provisioning of GKE cluster with VPC-native nodes and support for private networking (no public IP addresses)

## Private networking

Turned on with parameter `private`, this module reserves public IP, creates Cloud NAT gateway named `nat01` and Cloud router named `router01` and routes all egress traffic from cluster via NAT gateway.

## Node pools and node counts

This module deletes default GKE node pool and create new pool named `ackee-pool` (name just because of fact, that we are unicorns). This approach is recommended by TF documentation, because then you can change pool parameters (like SA permissions, node count etc.).

Amount of nodes is defined by `min_nodes` and `max_nodes` parameters, which set up autoscaling on node pool. Default values are 1 for both vars, which is effectively not autoscaling, but fits our needs very well :)

## Usage

```hcl
module "gke" {
  source            = "git::ssh://git@gitlab.ack.ee/Infra/terraform-gke-vpc.git?ref=v6.0.0"
  namespace         = var.namespace
  project           = var.project
  location          = var.location
  private           = false
  vault_secret_path = var.vault_secret_path
  min_nodes         = 1
  max_nodes         = 2
}
```

## Before you do anything in this module

Install pre-commit hooks by running following commands:

```shell script
brew install pre-commit terraform-docs
pre-commit install
```

## Example

Simple example on howto use this module could be found at folder `example`. Use `spinup_testing.sh` script to init
the environment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| google | ~> 3.19.0 |
| helm | ~> 1.2.3 |
| kubernetes | ~> 1.11.0 |
| random | ~> 2.1 |
| vault | ~> 2.7.1 |

## Providers

| Name | Version |
|------|---------|
| google | ~> 3.19.0 |
| helm | ~> 1.2.3 |
| kubernetes | ~> 1.11.0 |
| random | ~> 2.1 |
| vault | ~> 2.7.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| auto\_repair | Allow auto repair of node pool | `bool` | `true` | no |
| auto\_upgrade | Allow auto upgrade of node pool | `bool` | `false` | no |
| cluster\_ipv4\_cidr\_block | Optional IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. | `string` | `""` | no |
| cluster\_name | Name of GKE cluster, if not used, var.project is used instead | `string` | `""` | no |
| disk\_size\_gb | Size of the disk attached to each node, specified in GB. The smallest allowed disk size is 10GB. Defaults to 100GB. | `string` | `"100GB"` | no |
| enable\_traefik | Enable traefik helm chart for VPC | `bool` | `false` | no |
| location | Default GCP zone | `string` | `"europe-west3-c"` | no |
| machine\_type | Default machine type to be used in GKE nodepool | `string` | `"n1-standard-1"` | no |
| max\_nodes | Maximum number of nodes deployed in initial node pool | `number` | `1` | no |
| min\_nodes | Minimum number of nodes deployed in initial node pool | `number` | `1` | no |
| namespace | Default namespace to be created after GKE start | `string` | `"production"` | no |
| private | Flag stating if module should also create NAT & routing, also the nodes do not obtain public IP addresses | `bool` | `false` | no |
| private\_master | Flag to put endpoint into private subnet | `bool` | `false` | no |
| project | GCP project name | `string` | n/a | yes |
| region | GCP region | `string` | `"europe-west3"` | no |
| sealed\_secrets\_version | Version of sealed secret helm chart | `string` | `"v1.6.1"` | no |
| services\_ipv4\_cidr\_block | Optional IP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. | `string` | `""` | no |
| traefik\_custom\_values | Traefik Helm chart custom values list | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | <pre>[<br>  {<br>    "name": "ssl.enabled",<br>    "value": "true"<br>  },<br>  {<br>    "name": "rbac.enabled",<br>    "value": "true"<br>  }<br>]</pre> | no |
| traefik\_version | Version number of helm chart | `string` | `"1.7.2"` | no |
| upgrade\_settings | Upgrade settings for node pool of GKE | `any` | `null` | no |
| vault\_secret\_path | Path to secret in local vault, used mainly to save gke credentials | `string` | n/a | yes |
| vertical\_pod\_autoscaling | Allow auto upgrade of node pool | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | Client certificate used kubeconfig |
| client\_key | Client key used kubeconfig |
| cluster\_ca\_certificate | Client ca used kubeconfig |
| cluster\_ipv4\_cidr | The IP address range of the Kubernetes pods in this cluster in CIDR notation |
| cluster\_password | Cluster master password, keep always secret! |
| cluster\_username | Cluster master username, keep always secret! |
| endpoint | Cluster control plane endpoint |
| instance\_group\_urls | List of instance group URLs which have been assigned to the cluster |
| node\_pools | List of node pools associated with this cluster |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
