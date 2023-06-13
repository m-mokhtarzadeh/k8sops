resource "random_password" "grafana_admin_dashboard_password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "helm_release" "monitoring" {
  name             = "monitoring"
  namespace        = "monitoring"
  create_namespace = "true"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "46.6.0"
  timeout          = 720

  set {
    name  = "prometheus.prometheusSpec.retention"
    value = "30d"
  }

  set {
    name  = "prometheus.prometheusSpec.storageSpec.volumeClaimTemplate.spec.resources.requests.storage"
    value = "10Gi"
  }

  set {
    name  = "grafana.defaultDashboardsTimezone"
    value = "Asia/Tehran"
  }

  set {
    name  = "grafana.persistence.enabled"
    value = "true"
  }

  set {
    name  = "grafana.adminPassword"
    value = random_password.grafana_admin_dashboard_password.result
  }

#####
  set {
    name  = "prometheusOperator.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "prometheusOperator.image.repository"
    value = "prometheus-operator/prometheus-operator"
  }

  set {
    name  = "prometheusOperator.image.tag"
    value = ""
  }

#####

  set {
    name  = "alertmanager.alertmanagerSpec.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.image.repository"
    value = "prometheus/alertmanager"
  }

  set {
    name  = "alertmanager.alertmanagerSpec.image.tag"
    value = "v0.25.0"
  }

#####

  set {
    name  = "grafana.image.repository"
    value = "registry.mmokhtar.ir/library/grafana/grafana"
  }

  set {
    name  = "grafana.testFramework.image"
    value = "registry.mmokhtar.ir/library/bats/bats"
    # tag: v1.4.1
  }

  set {
    name = "grafana.initChownData.image.repository"
    value = "registry.mmokhtar.ir/library/busybox"
    # tag: 1.31.1
  }

  set {
    name = "grafana.sidecar.image.repository"
    value = "registry.mmokhtar.ir/library/kiwigrid/k8s-sidecar"
    # tag: 1.24.3
  }

######

  set {
    name  = "prometheusOperator.admissionWebhooks.patch.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "prometheusOperator.admissionWebhooks.patch.image.repository"
    value = "ingress-nginx/kube-webhook-certgen"
  }

  set {
    name  = "prometheusOperator.admissionWebhooks.patch.image.tag"
    value = "v20221220-controller-v1.5.1-58-g787ea74b6"
  }

######

  set {
    name  = "prometheusOperator.prometheusConfigReloader.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "prometheusOperator.prometheusConfigReloader.image.repository"
    value = "prometheus-operator/prometheus-config-reloader"
  }

  set {
    name = "kube-state-metrics.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "kube-state-metrics.image.repository"
    value = "kube-state-metrics/kube-state-metrics"
  }

  set {
    name  = "thanosRuler.thanosRulerSpec.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "thanosRuler.thanosRulerSpec.image.repository"
    value = "thanos/thanos"
  }

  set {
    name = "thanosRuler.thanosRulerSpec.image.tag"
    value = "v0.31.0"
  }

  set {
    name  = "prometheus-node-exporter.image.registry"
    value = "registry.mmokhtar.ir/library"
  }

  set {
    name  = "prometheus-node-exporter.image.repository"
    value = "prometheus/node-exporter"
  }

}