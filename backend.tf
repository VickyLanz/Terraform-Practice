

data "google_compute_network" "my-network" {
  name = var.network
}

terraform {
  backend "gcs" {
      bucket = "sai-demo-bucket-001"
      prefix = "GKE-CFT/state"    
  }
}