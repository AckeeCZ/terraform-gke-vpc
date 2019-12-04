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
