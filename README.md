Terraform module for Nginx Ingress Controller
==========================================

Terraform module used to create nginx ingress controller in Kubernetes via Helm. With simple syntax.

## Usage

#### For activate controller in ingress resource, please add this annotation to ingress:
    "kubernetes.io/ingress.class"    = "nginx"

#### GCP
```terraform
resource "google_compute_address" "ingress_ip_address" {
  name = "nginx-controller"
}

module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/kubernetes"

  ip_address = google_compute_address.ingress_ip_address.address
}
```

#### AWS
```terraform
module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/kubernetes"

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
```

## Inputs

| Name | Description | Type | Default |  Required |
|------|-------------|------|---------|:--------:|
| name  | Name of created helm release | `string` | `ingress-nginx` | no |
| namespace\_name  | Name of namespace where nginx controller should be deployed | `string` | `kube-system` | no |
| ip_address | External Static Address for loadbalancer (Doesn't work with AWS) | `string` | n/a | no |
| controller_kind | Controller type: DaemonSet, Deployment etc.. | `string` | `DaemonSet` | no |
| controller_daemonset_useHostPort | Also use host ports(80,443) for pods. Node Ports in services will be untouched | `bool` | `false` | no |
| controller_service_externalTrafficPolicy | Traffic policy for controller. See docs. | `string` | `Local` | no |
| controller_request_memory | Memory request for pod. Value in MB | `nubmer` | `140` | no |
| publish_service | Publish LoadBalancer endpoint to Service | `bool` | `true` | no |
| define_nodePorts | By default service using NodePorts. It can be generated automatically, or you can assign this ports number | `bool` | `true` | no |
| service_nodePort_http | NodePort number for http | `number` | `32001` | no |
| service_nodePort_https | NodePort number for https | `number` | `32002` | no |
| metrics_enabled | Allow exposing metrics for prometheus-operator | `bool` | `false` | no |
| disable_heavyweight_metrics | Disable some 'heavyweight' or unnecessary metrics | `bool` | `false` | no |
| additional\_set | Additional sets to Helm | <pre>list(object({<br>    name  = string<br>    value = string<br>    type  = string // Optional<br>  }))</pre> | `[]` |  no |

## Outputs
| Name | Description |
|------|:-----------:|
| name | Namespace used by nginx controller |
| namespace | Namespace used by nginx controller | 

## Terraform Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13.0 |
| helm | >= 2.1.0 |