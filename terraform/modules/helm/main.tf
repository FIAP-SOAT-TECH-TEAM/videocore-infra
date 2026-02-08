resource "helm_release" "newrelic_otel_collector" {
  name             = "videocore-otel"
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