resource "helm_release" "application" {
  name = local.helm_chart
  chart = local.helm_chart
  namespace = "kube-system"
  repository = data.helm_repository.estafette.metadata[0].name
  wait = "false"
  version = local.helm_template_version
  set {
    name = "controller.service.loadBalancerIP"
    value = var.ip_address
  }
}