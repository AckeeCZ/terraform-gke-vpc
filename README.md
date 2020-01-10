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
	source    = "git::ssh://git@gitlab.ack.ee/Infra/terraform-gke-vpc.git?ref=v5.4.1"
	namespace = var.namespace
	project   = var.project
	location  = var.location
	private   = false
	min_nodes = 1
	max_nodes = 2
}
```
