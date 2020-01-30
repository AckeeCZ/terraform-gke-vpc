resource "vault_generic_secret" "default" {
  path      = "${var.vault_secret_path}/gke/credentials"
  data_json = <<EOT
{
  "cluster_username": "${random_string.cluster_username.result}",
  "cluster_password": "${random_string.cluster_password.result}"
}
EOT
}
