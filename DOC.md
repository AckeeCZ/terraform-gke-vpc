## Providers

| Name | Version |
|------|---------|
| google | ~> 2.20.0 |
| google-beta | ~> 3.6 |
| helm | ~> 0.10.4 |
| kubernetes | ~> 1.10.0 |
| random | ~> 2.1 |
| vault | ~> 2.7.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| auto\_repair | Allow auto repair of node pool | `bool` | `true` | no |
| auto\_upgrade | Allow auto upgrade of node pool | `bool` | `false` | no |
| cluster\_ipv4\_cidr\_block | Optional IP address range for the cluster pod IPs. Set to blank to have a range chosen with the default size. | `string` | `""` | no |
| enable\_traefik | Enable traefik helm chart for VPC | `bool` | `false` | no |
| location | n/a | `string` | `"europe-west3-c"` | no |
| machine\_type | n/a | `string` | `"n1-standard-1"` | no |
| max\_nodes | n/a | `number` | `1` | no |
| min\_nodes | n/a | `number` | `1` | no |
| namespace | n/a | `string` | `"production"` | no |
| private | n/a | `bool` | `false` | no |
| private\_master | n/a | `bool` | `false` | no |
| project | n/a | `any` | n/a | yes |
| region | n/a | `string` | `"europe-west3"` | no |
| sealed\_secrets\_version | n/a | `string` | `"v1.6.1"` | no |
| services\_ipv4\_cidr\_block | dIP address range of the services IPs in this cluster. Set to blank to have a range chosen with the default size. | `string` | `""` | no |
| tiller\_image | n/a | `string` | `"gcr.io/kubernetes-helm/tiller:v2.15.1"` | no |
| traefik\_custom\_values | Traefik Helm chart custom values list | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))<br></pre> | <pre>[<br>  {<br>    "name": "ssl.enabled",<br>    "value": "true"<br>  },<br>  {<br>    "name": "rbac.enabled",<br>    "value": "true"<br>  }<br>]<br></pre> | no |
| traefik\_version | Version number of helm chart | `string` | `"1.7.2"` | no |
| upgrade\_settings | Upgrade settings for node pool of GKE | `map` | `{}` | no |
| vault\_secret\_path | n/a | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| client\_certificate | n/a |
| client\_key | n/a |
| cluster\_ca\_certificate | n/a |
| cluster\_ipv4\_cidr | n/a |
| cluster\_password | n/a |
| cluster\_username | n/a |
| endpoint | n/a |
| instance\_group\_urls | n/a |
| node\_pools | n/a |

