# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v5.3.0] - 2019-12-03
### Added
- Add parameter `private` - allows to switch if we want or do not want private cluster (controls creation of NAT gateway and router)
- Add parameter `private_master` - allows to create master without public endpoint - master then can be reached only from VPC, we currently does not support this
### Fixed
- backward compatibility with v5.2.1 - we create completely new node-pool which means that we do not need to redeploy cluster to changes pool OAuth scopes
### Changed
- we now utilize `google_container_node_pool` resource to create node-pool - now node pool definition is independent on cluster definition

## [v5.2.2] - 2019-12-01
- Add compute scope to allow Elasticsearch discovery

## [v5.2.1] - 2019-11-12
- change Helm definition to TF0.12 syntax, add helm_repository data to force TF to install Tiller

## [v5.2.0] - 2019-11-11
- Install Tiller and setup Helm by Terraform

## [v5.1.0] - 2019-11-11
- Remove compute OAuth scope. It is potentially dangerous (https://redmine.ack.ee/issues/38969)

## [v5.0.0] - 2019-11-11
- upgrade to Terraform 0.12

## [v2.0.0] - 2019-10-17
- Change password generation - remove special chars (https://github.com/kubernetes/kubernetes/issues/65633) -
this changes forces regeneration of random_string resources, which then tries to change cluster credentials, which ...
fails. Credentials can be fetched from GCP Console and written to TF state manually tho.

### Manual fixing of TF state :

Fetch Terraform state with :
```
terraform state pull > /tmp/state
```
Find `random_string.cluster_password` here, edit it's `id` and `result` fields to value from GKE (it can be read with
`terraform state show module.gke.google_container_cluster.primary | grep password`), Same of `random_string.cluster_username`
and `terraform state show module.gke.google_container_cluster.primary | grep username`

Then save the file and upload it back :
```
terraform state push /tmp/state
```

This change do not force GKE cluster recreation, but requires manual intevervention, so bumping major ver.

## [v1.1.0] - 2019-10-08
- remove some unnecessary permission from GKE Service Account

## [v1.0.0] - 2019-09-25
- initialization, import from https://gitlab.ack.ee/Infra/cosmo-infrastruktura-production/tree/master/tf/gke
