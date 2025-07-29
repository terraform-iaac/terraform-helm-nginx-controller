resource "helm_release" "application" {
  name             = var.name
  namespace        = var.namespace
  create_namespace = var.create_namespace
  chart            = local.helm_chart
  repository       = local.helm_repository
  version          = var.chart_version
  atomic           = var.atomic
  wait             = var.wait
  timeout          = var.timeout

  values = [var.disable_heavyweight_metrics ? file("${path.module}/templates/metrics-disable.yaml") : ""]

  set_list = var.additional_set_list
  set = concat(
    [
      {
        name  = "controller.kind"
        value = var.controller_kind
      },
      {
        name  = "controller.ingressClassResource.name"
        value = var.ingress_class_name
      },
      {
        name  = "controller.ingressClassResource.default"
        value = var.ingress_class_is_default
      },
      {
        name  = "controller.daemonset.useHostPort"
        value = var.controller_daemonset_useHostPort
      },
      {
        name  = "controller.service.externalTrafficPolicy"
        value = var.controller_service_externalTrafficPolicy
      },
      {
        name  = "controller.publishService.enabled"
        value = var.publish_service
      },
      {
        name  = "controller.resources.requests.memory"
        type  = "string"
        value = "${var.controller_request_memory}Mi"
      }
    ],
    local.controller_service_nodePorts,
    local.loadBalancerIP,
    local.metrics_enabled,
    var.additional_set
  )
}
