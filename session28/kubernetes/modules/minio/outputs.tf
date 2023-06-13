output "minio_admin_password" {
	value = "${random_password.minio.result}"
	sensitive = true
}