# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v11.4.0] - 2022-04-20
### Changed
- dependencies versions upgrade

## [v11.3.0] - 2022-02-21
### Added
- preemptible instances node pool allowed attribute

## [v11.2.0] - 2022-02-01
### Added
- default node pool name as variable

## [v11.1.1] - 2022-01-22
### Fixed
- missing node pool `workload_metadata_config` value `GKE_METADATA` when `workload_identity_config` is enabled

## [v11.1.0] - 2021-12-08
### Added
- monitoring components setup

## [v11.0.0] - 2021-11-16
### Changed
- `workload_identity_config.identity_namespace` changed to `workload_identity_config.workload_pool` - upstream change
- Structure of example upgraded for Terraform 0.13+
- Utilize NAT module and create private cluster in example
### Removed
- `instance_group_urls` output - dropped from upstream

## [v10.0.0] - 2021-10-25
### Changed
- `oauth_scopes` for the node pool to variable
- set only `https://www.googleapis.com/auth/cloud-platform` scope in case `workload_identity_config` is enabled

## [v9.8.0] - 2021-09-30
### Added
- Workload identity support

## [v9.7.0] - 2021-09-22
### Added
- Add `min_master_version` as fixed parameter due to possible issues with compatibility of other components (Argo, Istio, ...)

## [v9.6.1] - 2021-08-18
### Changed
- Upgrade providers in example to latest versions
### Fixed
- Remove empty provider definitions which produced warning notices

## [v9.6.0] - 2021-07-14
### Added
- Add default namespace's labels

## [v9.5.0] - 2021-05-18
### Added
- Parameterize hardcoded variables

## [v9.4.0] - 2021-04-19
### Changed
- Remove `load_config_file` parameter from `kubernetes` and `helm` providers - this allows their upgrade to version 2
- Bump `kubernetes` provider version in example

## [v9.3.0] - 2021-03-16
### Changed
- Traefik Helm chart repo to new upstream: https://helm.traefik.io/traefik

## [v9.2.0] - 2021-03-10
### Added
- Add `node_locations` option in `var.node_pools` variable

## [v9.1.0] - 2021-02-15
### Changed
- Change README usage description

## [v9.0.0] - 2021-01-31
### Removed
- Remove basic k8s `master_auth`.
### Added
- Add access token for k8s `master_auth`.
- Mutiple cluster in one zone compatibility

## [v8.2.0] - 2020-12-28
### Fixed
- Fix sealed secrets Helm chart repo URL
### Changed
- Bump default version of sealed secret

## [v8.1.0] - 2020-12-22
### Changed
- Changed sealed secrets to be created conditionally

## [v8.0.0] - 2020-12-09
### Changed
- Required Terraform version bumped to 0.13

## [v7.3.0] - 2020-10-29
### Changed
- Changed node pool definition to allow custom nodepools

## [v7.2.0] - 2020-09-16
### Changed
- Remove providers locking - this should be done in main module in infrastructure repo from now on.
- Add locking to `example/main.tf`
- Remove executable permissions from `example/spinup_testing.sh` - it should never be run directly, but must be used with `source` cmd.

## [v7.1.1] - 2020-09-10
### Changed
- Upgrade random provider lock to `~> 2.3.0`

## [v7.1.0] - 2020-07-29
### Added
- Add NodeLocal DNS Cache turned on by `dns_nodelocal_cache` parameter. **Enabling/Disabling NodeLocal DNSCache in an existing cluster is a disruptive operation. All cluster nodes running GKE 1.15 and higher are recreated.**

## [v7.0.0] - 2020-07-21
### Added
- `network` variable allows to specify VPC network name
- `private_master_subnet` variable allows to specify subnet of private GKE master. It must be unique within VPC network and must be /28 mask
### Changed
- Firewall rule for sealed-secrets changed it's name so we can deploy multiple private clusters
- Vault secret changed it's path so we can deploy multiple private clusters
### Breaking changes
- Remove Cloud NAT GW creation, instead add example how to utilize https://github.com/terraform-google-modules/terraform-google-cloud-nat - this affects private clusters which must first delete and then recreate NAT GW with external module

## [v6.6.1] - 2020-07-20
### Changed
- `disk_size_gb` is numeric value - fix previous version
- sealed-secrets Helm chart is now called without stable prefix - fix previous version

## [v6.6.0] - 2020-07-20
### Added
- `disk_size_gb` variable to set default disk size of node pool

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
