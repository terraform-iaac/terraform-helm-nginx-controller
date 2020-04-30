locals {
  helm_repo_url = "https://kubernetes-charts.storage.googleapis.com"
  helm_repo_name = "stable"
  helm_chart = "nginx-ingress"
  helm_template_version = "1.36.2"
  set = [
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
  ]
}

variable "ip_address" {
  type = string
  description = "(Required) External Static Address for loadbalancer"
}