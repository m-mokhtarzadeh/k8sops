output "grafana_admin_dashboard_password" {
  value = random_password.grafana_admin_dashboard_password.result
}
