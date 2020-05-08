locals {
  helm_chart = "nginx-ingress"
  helm_template_version = "1.36.2"
}

variable "ip_address" {
  type = string
  description = "(Required if 'set' have default value) External Static Address for loadbalancer"
  default = null
}

variable "set" {
  description = "(Optional) Add params for helm."
  default = []
}