resource "helm_release" "velero" {
  name             = "velero"
  namespace        = "velero"
  create_namespace = "true"
  repository       = "https://vmware-tanzu.github.io/helm-charts/"
  chart            = "velero"
  version          = "4.0.2"
  values = [
    templatefile("${path.module}/values.tftpl", {
			aws_access_key_id = "${var.aws_access_key_id}",
			aws_secret_access_key = "${var.aws_secret_access_key}"
		}),
		"${file("${path.module}/values.yml")}"
  ]
}
