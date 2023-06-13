resource"kubernetes_namespace" "minio" {
  metadata {
    name = "minio"
  }
}

resource "random_password" "minio" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "helm_release" "minio" {
  name             = "minio"
  namespace        = kubernetes_namespace.minio.metadata.0.name
  create_namespace = "false"
  repository       = "https://charts.bitnami.com/bitnami"
  chart            = "minio"
  version          = "12.6.4"
  set {
    name  = "auth.rootPassword"
    value = "${random_password.minio.result}"
  }
  set {
    name = "image.registry"
    value = "registry.mmokhtar.ir/library"
  }
  set {
    name = "image.repository"
    value = "bitnami/minio"
  }
  set {
    name = "image.tag"
    value = "2023.5.18-debian-11-r2"
  }
}
