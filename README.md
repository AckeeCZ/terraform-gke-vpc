# Terraform Google Kubernetes Engine VPC-native module

Terraform module for provisioning of GKE cluster with VPC-native nodes and support for private networking (no public IP addresses)

## Private networking

Turned on with parameter `private`, this module reserves public IP, creates Cloud NAT gateway named `nat01` and Cloud router named `router01` and routes all egress traffic from cluster via NAT gateway.

## Usage

```hcl
module "gke" {
	source    = "git::ssh://git@gitlab.ack.ee/Infra/terraform-gke-vpc.git?ref=v5.3.1"
	namespace = var.namespace
	project   = var.project
	location  = var.location
	private   = false
}
```
