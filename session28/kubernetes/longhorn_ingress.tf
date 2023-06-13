resource "htpasswd_password" "longhorn-password" {
  password = "longhorn"
  salt     = substr(sha512("longhorn"), 0, 8)
}

resource "kubernetes_secret_v1" "longhorn-ui-auth" {
  metadata {
    name      = "basic-auth"
    namespace = "longhorn-system"
  }
  data = {
    auth = "longhorn:${htpasswd_password.longhorn-password.bcrypt}"
  }
}

resource "kubernetes_ingress_v1" "longhorn" {
  metadata {
    name = "longhorn"
		namespace = "longhorn-system"
    annotations = {
      "kubernetes.io/ingress.class"             = "nginx"
      "nginx.ingress.kubernetes.io/auth-type"   = "basic"
      "nginx.ingress.kubernetes.io/auth-secret" = "basic-auth"
      "nginx.ingress.kubernetes.io/auth-realm"  = "Authentication Required"
    }
  }

  spec {
    rule {
			host = "longhorn.mmokhtar.ir"
      http {
        path {
          path = "/"
          backend {
						service {
              name = "longhorn-frontend"
							port {
								 number = 80
							}
						}
          }
        }
      }
    }
  }
}
