resource "kubernetes_namespace" "elasticsearch" {
  metadata {
    name = "elasticsearch"
  }
}

resource "kubernetes_secret" "elastic-credentials" {
  metadata {
    name      = "elastic-credentials"
    namespace = kubernetes_namespace.elasticsearch.metadata.0.name
  }
  data = {
    username = "elastic"
    password = "elastic"
  }
}

resource "helm_release" "elasticsearch" {
  depends_on = [ 
    kubernetes_secret.elastic-credentials
  ]
  name             = "elasticsearch"
  namespace        = kubernetes_namespace.elasticsearch.metadata.0.name
  create_namespace = "false"
  chart            = "${path.root}/charts/elasticsearch-7.17.3.tgz"
  timeout          = 720
  values = [
    file("${path.module}/elastic_values.yml"),
  ]
}

resource "helm_release" "kibana" {
  depends_on = [
    helm_release.elasticsearch
  ]
  name             = "kibana"
  namespace        = kubernetes_namespace.elasticsearch.metadata.0.name
  create_namespace = "false"
  chart            = "${path.root}/charts/kibana-7.17.3.tgz"
  timeout          = 720
  values = [
    file("${path.module}/kibana_values.yml"),
  ]
}

resource "helm_release" "fluentbit" {
  depends_on = [
    helm_release.elasticsearch,
    helm_release.kibana
  ]
  name             = "fluent-bit"
  namespace        = kubernetes_namespace.elasticsearch.metadata.0.name
  create_namespace = "false"
  repository       = "https://fluent.github.io/helm-charts"
  chart            = "fluent-bit"
  version          = "0.20.1"
  timeout          = 720
  values = [
    file("${path.module}/fluent_values.yml"),
  ]
}
