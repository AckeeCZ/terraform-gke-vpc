variable "location" {
  default = "europe-west3-c"
}

variable "region" {
  default = "europe-west3"
}

variable "project" {
}

variable "namespace" {
  default = "production"
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "private" {
  default = false
  type    = bool
}

variable "private_master" {
  default = false
  type    = bool
}

variable "sealed_secrets_version" {
  default = "v1.6.1"
}

variable "min_nodes" {
  default = 1
}

variable "max_nodes" {
  default = 1
}
