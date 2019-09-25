# Terraform Google Kubernetes Engine VPC-native module

Terraform module for provisioning of GKE cluster with VPC-native nodes and private networking (no public IP addresses)

## Usage

```hcl
module "gke" {
	source = "git::ssh://git@gitlab.ack.ee/Infra/terraform-gke-vpc.git?ref=v1.0.0"
	namespace = "${var.namespace}"
	project = "${var.project}"
	zone = "${var.zone}"
}
```