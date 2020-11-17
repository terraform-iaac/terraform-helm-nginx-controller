resource "helm_release" "application" {
  name = var.name
  chart = local.helm_chart
  namespace = var.namespace
  repository = local.helm_repository
  wait = "false"
  version = local.helm_template_version

  values = [var.disable_heavyweight_metrics ? file("${path.module}/templates/metrics-disable.yaml") : ""]

  set {
    name  = "controller.kind"
    value = var.controller_kind
  }
  set {
    name = "controller.daemonset.useHostPort"
    value = var.controller_daemonset_useHostPort
  }
  set {
    name = "controller.service.externalTrafficPolicy"
    value = var.controller_service_externalTrafficPolicy
  }

  dynamic "set" {
    for_each = local.controller_service_nodePorts
    content {
      name = set.value.name
      value = set.value.value
    }
  }

  dynamic "set" {
    for_each = local.loadBalancerIP
    content {
      name = set.value.name
      value = set.value.value
    }
  }

  dynamic "set" {
    for_each = local.metrics_enabled
    content {
      name = set.value.name
      value = set.value.value
    }
  }

  dynamic "set" {
    for_each = var.additional_set
    content {
      name = set.value.name
      value = set.value.value
      type = lookup(set.value, "type", null )
    }
  }
}