# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v6.5.0] - 2020-07-20
### Changed
- Upgrade Helm provider lock to `~> 1.2.3`
### Removed
- Removed `helm_repository` declaration, because it is deprecated now

## [v6.4.0] - 2020-05-12
### Added
- Add example folder
- Add pre-commit hooks for formatting and documentation
- Add `.editorconfig`
### Fixed
- Fix multiple typos in `CHANGELOG.md`

## [v6.3.0] - 2020-05-04
### Changed
- Upgrade Google GA provider lock to `~> 3.19.0`, remove `google-beta` provider as all needed versions are now in GA. Note: this upgrade should need upgrade of other TF modules to satisfy same version of `google` provider. For compatible versions, see: https://redmine.ack.ee/issues/43227#note-11

## [v6.2.0] - 2020-04-16
### Added
- Add support for Vertical Pod Autoscaler, controlled by `vertical_pod_autoscaling` variable with default value of true

## [v6.1.0] - 2020-04-15
### Changed
- Upgrade Kubernetes provider lock to `~> 1.11.0`

## [v6.0.0] - 2020-04-08
### Changed
- Upgrade Helm provider to version `~> 1.1.1` to suport Helm v3 migration. Upgrade path: https://redmine.ack.ee/issues/39907#note-11
- From this version, ONLY HELM V3 IS SUPPORTED
### Added
- Add `https://containous.github.io/traefik-helm-chart` Helm repository - preparation for Traefik 2 migration (https://redmine.ack.ee/issues/43876)

## [v5.9.0] - 2020-03-23
### Added
- Add optional parameters `cluster_name` in case multiple clusters need to be deployed in the project

## [v5.8.1] - 2020-02-05
- Fix of wrong TF comparison between empty map and null for update nodepool settings

## [v5.8.0] - 2020-02-03
### Added
- Add optional parameters `cluster_ipv4_cidr_block` and `services_ipv4_cidr_block` which we can use to override default CIDR allocations of new GKE cluster

## [v5.7.0] - 2020-01-30
### Changed
- Moved required version of google-beta to ~> 3.6
### Added
- Add `upgrade_settings` with `max_surge = 1` and `max_unavailable = 1` as default values

## [v5.6.2] - 2020-01-30
### Added
- Add `auto_upgrade` and `auto_repair` parameters with default values for node pool

## [v5.6.1] - 2020-01-16
### Added
- Add `initial_node_count` parameter with value of one for `google_container_node_pool`

## [v5.6.0] - 2020-01-16
### Added
- Install Traefik 1.7.2 [helm chart](https://github.com/helm/charts/tree/master/stable/traefik).

## [v5.5.1] - 2020-01-14
### Added
- Add optional parameter `tiller_image`, that is passed to Helm provider and controls version of Tiller image installed.

## [v5.5.0] - 2020-01-11
### Added
- add required `vault_secret_path` parameter. This allows storing random generated cluster credentials to Vault. Value is root path for storing of secret and is passed from main module. See example [Jenkinsfile](https://gitlab.ack.ee/Ackee/infrastruktura/blob/7b3a45c804beb47edd19ec13e7d3b336a2ca73a6/Jenkinsfile#L7) and [main module variable](https://gitlab.ack.ee/Ackee/infrastruktura/blob/7b3a45c804beb47edd19ec13e7d3b336a2ca73a6/tf/variables.tf). This variable should always be set to this var, eg. `vault_secret_path = var.vault_secret_path`. Also, please see Redmine [ticket](https://redmine.ack.ee/issues/38677)
- lock Vault provider to version `~> 2.7.1`

## [v5.4.1] - 2020-01-10
### Changed
- Bump Kubernetes provider version to 1.10 and Google provider to 2.20

## [v5.4.0] - 2020-01-03
### Added
- Add `min_nodes` and `max_nodes` parameters

## [v5.3.1] - 2019-12-16
### Added
- Install bitnami [sealed-secrets](https://github.com/bitnami-labs/sealed-secrets).

## [v5.3.0] - 2019-12-03
### Added
- Add parameter `private` - allows to switch if we want or do not want private cluster (controls creation of NAT gateway and router)
- Add parameter `private_master` - allows to create master without public endpoint - master then can be reached only from VPC, we currently does not support this
### Fixed
- Backward compatibility with v5.2.1 - we create completely new node-pool which means that we do not need to redeploy cluster to changes pool OAuth scopes
### Changed
- We now utilize `google_container_node_pool` resource to create node-pool - now node pool definition is independent on cluster definition

## [v5.2.2] - 2019-12-01
### Added
- Add compute scope to allow Elasticsearch discovery

## [v5.2.1] - 2019-11-12
### Changed
- Change Helm definition to TF0.12 syntax, add helm_repository data to force TF to install Tiller

## [v5.2.0] - 2019-11-11
### Added
- Install Tiller and setup Helm by Terraform

## [v5.1.0] - 2019-11-11
### Removed
- Remove compute OAuth scope. It is potentially dangerous (https://redmine.ack.ee/issues/38969)

## [v5.0.0] - 2019-11-11
### Added
- Upgrade to Terraform 0.12

## [v2.0.0] - 2019-10-17
### Changed
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

This change do not force GKE cluster recreation, but requires manual intervention, so bumping major ver.

## [v1.1.0] - 2019-10-08
### Removed
- Remove some unnecessary permission from GKE Service Account

## [v1.0.0] - 2019-09-25
### Added
- Initialization, import from https://gitlab.ack.ee/Infra/cosmo-infrastruktura-production/tree/master/tf/gke
