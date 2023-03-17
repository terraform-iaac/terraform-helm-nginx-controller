Terraform module for Nginx Ingress Controller
==========================================

Terraform module used to create nginx ingress controller in Kubernetes via Helm. With simple syntax.

## Usage

### IngressClass 
By default, all new ingresses use this controller as default. 

If you have already default IngressClass specified, please set `ingress_class_is_default=false`. \
In this case you should specify `ingressClassName` to your ingress manually.

#### GCP
```terraform
resource "google_compute_address" "ingress_ip_address" {
  name = "nginx-controller"
}

module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/helm"

  ip_address = google_compute_address.ingress_ip_address.address
}
```

#### AWS
```terraform
module "nginx-controller" {
  source  = "terraform-iaac/nginx-controller/helm"

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
| namespace  | Name of namespace where nginx controller should be deployed | `string` | `kube-system` | no |
| chart\_version  | HELM Chart Version for controller ( It is not recommended to change )| `string` | `4.0.6` | no |
| atomic  | If set, installation process purges chart on fail | `bool` | `false` | no |
| ingress\_class\_name  | IngressClass resource name | `string` | `nginx` | no |
| ingress\_class\_is_default  | IngressClass resource default for cluster | `bool` | `true` | no |
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
| wait | Will wait until all resources are in a ready state" | `bool` | `true` | no |
| timeout | Time in seconds to wait for any individual kubernetes operation | `number` | `300` | no |

## Outputs
| Name | Description |
|------|:-----------:|
| name | Namespace used by nginx controller |
| namespace | Namespace used by nginx controller | 
| ingress\_class\_name | IngressClass name for this controller | 

## Terraform Requirements

| Name | Version  |
|------|----------|
| terraform | >= 1.3.0 |
| helm | >= 2.5.0 |

## Kubernetes version: `>=1.19`
