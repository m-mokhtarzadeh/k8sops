resource "helm_release" "nginx" {
  name             = "nginx"
  namespace        = "nginx-ingress"
  create_namespace = "true"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "nginx-ingress-controller"
  version          = "9.7.2"
	set {
		name = "global.imageRegistry"
		value = "registry.mmokhtar.ir/library"
	}
	set {
		name = "service.type"
		value = "NodePort"
	}
	set {
		name = "hostNetwork"
		value = "true"
	}
	set {
		name = "kind"
		value = "DaemonSet"
	}
}
