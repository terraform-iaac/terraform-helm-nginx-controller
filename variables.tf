locals {
  helm_chart = "ingress-nginx"
  helm_repository = "https://kubernetes.github.io/ingress-nginx"
  helm_template_version = "3.10.1"

  loadBalancerIP = var.ip_address == null ? [] : [
    {
      name = "controller.service.loadBalancerIP"
      value = var.ip_address
    }
  ]

  metrics_enabled = var.metrics_enabled ? [
    {
      name = "controller.metrics.enabled"
      value = "true"
    },
    {
      name = "controller.metrics.serviceMonitor.enabled"
      value = "true"
    },
    {
      name = "controller.metrics.serviceMonitor.additionalLabels.release"
      value = "kube-prometheus-stack"
    }
  ] : []

  controller_service_nodePorts = var.define_nodePorts ? [
    {
      name = "controller.service.nodePorts.http"
      value = var.service_nodePort_http
    },
    {
      name = "controller.service.nodePorts.https"
      value = var.service_nodePort_https
    }
  ] : []
}

variable "define_nodePorts" {
  description = "Define NodePorts or assign automatically"
  type = string
  default = true
}
variable "ip_address" {
  type = string
  description = "(Optional) External Static Address for loadbalancer (Not work with AWS)"
  default = null
}

variable "additional_set" {
  description = "Add additional set for helm"
  default = []
}

variable "controller_daemonset_useHostPort" {
  type = string
  default = "true"
}
variable "controller_service_externalTrafficPolicy" {
  type = string
  default = "Local"
}
variable "controller_kind" {
  type = string
  default = "DaemonSet"
}
variable "metrics_enabled" {
  type = bool
  default = false
}
variable "service_nodePort_http" {
  type = string
  default = "32001"
}
variable "service_nodePort_https" {
  type = string
  default = "32002"
}

variable "namespace" {
  type = string
  default = "kube-system"
}

variable "name" {
  description = "(Optional) Name of helm release"
  default = "ingress-nginx"
}

variable "disable_heavyweight_metrics" {
  description = "Disable some 'heavyweight' or unnecessary metrics"
  type = bool
  default = false
}
