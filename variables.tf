locals {
  helm_repo_url = "https://kubernetes-charts.storage.googleapis.com"
}

locals {
  helm_repo_name = "stable"
}

locals {
  helm_chart = "nginx-ingress"
}

locals {
  helm_template_version = "1.36.0"
}

locals {
  set = [
    {
      name = "controller.service.loadBalancerIP"
      value = var.ip_address
    },
    {
      name = "controller.service.externalTrafficPolicy"
      value = "Local"
    }
  ]
}

variable "ip_address" {
  description = "(Required) External Static Address for loadbalancer"
}