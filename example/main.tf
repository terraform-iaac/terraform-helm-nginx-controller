### GCP
# Reserving External IP address. Can used for all urls. IMPORTANT: Do not delete this resource, you will lose your ip.
resource "google_compute_address" "ingress_ip_address" {
  name = "nginx-controller"
}

module "nginx-controller" {
  source = "../"

  ip_address = google_compute_address.ingress_ip_address.address
}

### AWS
module "nginx-controller" {
  source = "../"

  additional_set = [
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-type"
      value = "nlb"
      type  = "string"
    },
    {
      name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/aws-load-balancer-cross-zone-load-balancing-enabled"
      value = "true"
      type  = "string"
    }
  ]
}