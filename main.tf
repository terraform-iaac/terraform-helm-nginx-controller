resource "helm_release" "application" {
  name = local.helm_chart
  chart = local.helm_chart
  namespace = "kube-system"
  repository = "stable"
  wait = "false"
  version = local.helm_template_version
  dynamic "set" {
    for_each = var.set == [] ? [
      {
        name = "controller.daemonset.useHostPort"
        value = "true"
      },
      {
        name = "controller.service.loadBalancerIP"
        value = var.ip_address
      },
      {
        name = "controller.service.externalTrafficPolicy"
        value = "Local"
      },
      {
        name = "controller.kind"
        value = "DaemonSet"
      }
    ] : var.set
    content {
      name = set.value.name
      value = set.value.value
      type = lookup(set.value, "type", null )
    }
  }
}