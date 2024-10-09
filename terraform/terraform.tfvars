region         = "North Europe"
rg-name        = "kubespray"
cidr           = "10.255.0.0/16"

kubespray = {
  "name" = "k8s-subnet"
  "cidr" = "10.255.0.0/20"
}
