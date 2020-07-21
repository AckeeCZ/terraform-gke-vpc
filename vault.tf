resource "vault_generic_secret" "default" {
  path = "${var.vault_secret_path}/gke/${var.location}/credentials"
  data_json = jsonencode(
    {
      cluster_username = random_string.cluster_username.result
      cluster_password = random_string.cluster_password.result
    }
  )
}
