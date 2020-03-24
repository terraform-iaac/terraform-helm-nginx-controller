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
  helm_template_version = "1.34.2"
}

variable "ip_address" {
  description = "(Required) External Static Address for loadbalancer"
}