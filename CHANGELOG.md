# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [v5.0.0] - 2019-11-11
- upgrade to Terraform 0.12

## [v2.0.0] - 2019-10-17
- Change password generation - remove special chars (https://github.com/kubernetes/kubernetes/issues/65633) -
this changes forces regeneration of random_string resources, which then tries to change cluster credentials, which ...
fails. Credentials can be fetched from GCP Console and written to TF state manually tho.

This change do not force GKE cluster recreation, but requires manual intevervention, so bumping major ver.

## [v1.1.0] - 2019-10-08
- remove some unnecessary permission from GKE Service Account

## [v1.0.0] - 2019-09-25
- initialization, import from https://gitlab.ack.ee/Infra/cosmo-infrastruktura-production/tree/master/tf/gke
