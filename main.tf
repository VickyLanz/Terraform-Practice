provider "google" {
    project = var.project_id
    region = var.region  
}

resource "google_container_cluster" "k8-app-cluster" {
    name = var.cluster_name
    location = "${var.region}-a"
    project = var.project_id
    initial_node_count = 2
   #logging_service = "TRUE"
}

data "google_client_config" "default" {}


module "gke_auth" {
  source               = "terraform-google-modules/kubernetes-engine/google//modules/auth"

  project_id           = var.project_id
  cluster_name         = google_container_cluster.k8-app-cluster.name
  location             = google_container_cluster.k8-app-cluster.location
  use_private_endpoint = false
}
provider "kubernetes" {
  host                   = "https://${google_container_cluster.k8-app-cluster.endpoint}"
  token                  = data.google_client_config.default.access_token
#   cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  cluster_ca_certificate = module.gke_auth.cluster_ca_certificate

}
resource "kubernetes_deployment" "k8-deploy" {
  metadata {
    name = "k8-app"
    labels = {
      app="k8-app-prod"
    }
  }
  spec {

    selector {
      match_labels = {
        app="k8-app-prod"
      }
    }
    replicas = "3"
    template {
      metadata {
        labels = {
          app="k8-app-prod"
        }
      }
      spec {
        container {
          name = "k8-app"
           image="gcr.io/triple-baton-337806/image-test@sha256:0a7e322c7085a174c52a0e77026e99131a6e262fd307c36636a0873e740bea75"
        }
      }
    }
  }
}


resource "kubernetes_service" "k8-app-service" {
  depends_on = [kubernetes_deployment.k8-deploy]
  metadata {
    name = "k8-app-service"
    labels = {
      app="k8-app-prod"
    }
  }
  spec {
    port {
      port = 8080
      protocol = "TCP"
      target_port = 80
    }
    selector = {
      app="k8-app-prod"
    }
    session_affinity = "ClientIP"
    type = "LoadBalancer"

  }
}

