resource "helm_release" "newrelic_otel_collector" {
  name             = "videocore-nr-k8s-otel"
  repository       = var.newrelic_otel_collector_repository
  chart            = var.newrelic_otel_collector_chart_name
  namespace        = var.newrelic_otel_collector_namespace
  version          = var.newrelic_otel_collector_chart_version

  set {
    name  = "cluster"
    value = var.newrelic_cluster_name
  }

  set_sensitive {
    name  = "licenseKey"
    value = var.newrelic_license_key
  }

  set {
    name  = "lowDataMode"
    value = tostring(var.newrelic_low_data_mode)
  }

  set {
    name  = "importantMetricsOnly"
    value = tostring(var.newrelic_important_metrics_only)
  }
}

resource "helm_release" "otel_collector" {
  name       = "videocore-nr-otel"
  repository = var.otel_collector_repository
  chart      = var.otel_collector_chart_name
  namespace  = var.newrelic_otel_collector_namespace

  set {
    name  = "image.repository"
    value = var.otel_collector_image_repository
  }

  set {
    name  = "mode"
    value = var.otel_collector_mode
  }

  values = [
    yamlencode({
      config = yamldecode(file("${path.module}/otel-config.yaml"))

      extraEnvs = [
        {
          name  = "LOG_EXPORTER_LOG_VERBOSITY"
          value = var.otel_log_exporter_verbosity
        },
        {
          name  = "NEW_RELIC_API_KEY"
          value = var.newrelic_license_key
        }
      ]
    })
  ]
}