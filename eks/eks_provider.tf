provider "kubernetes" {
  host                   = module.control_plane.cluster_endpoint
  token                  = module.control_plane.cluster_token
  cluster_ca_certificate = base64decode(module.control_plane.cluster_ca)
}

provider "helm" {
  kubernetes {
    host                   = module.control_plane.cluster_endpoint
    token                  = module.control_plane.cluster_token
    cluster_ca_certificate = base64decode(module.control_plane.cluster_ca)
  }
}

provider "tls" {}
