# Google Provider Setup
provider "google" {
  project = var.project_id
  region  = var.region
}

# Data Resource to Get Cluster Information
data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

# Kubernetes Provider Setup
provider "kubernetes" {
  host                   = data.google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

# Helm Provider Setup (Using Kubernetes credentials)
provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}

# GKE Cluster Resource (Ensure the cluster is correctly set up)
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region

  # Other cluster settings...
}

# Helm release for delegate
module "delegate" {
  source = "harness/harness-delegate/kubernetes"
  version = "0.1.8"

  account_id     = "ucHySz2jQKKWQweZdXyCog"
  delegate_token = "NTRhYTY0Mjg3NThkNjBiNjMzNzhjOGQyNjEwOTQyZjY="
  delegate_name  = "terraform-delegate"
  deploy_mode    = "KUBERNETES"
  namespace      = "harness-delegate-ng"
  manager_endpoint = "https://app.harness.io"
  delegate_image = "harness/delegate:25.02.85300"
  replicas       = 1
  upgrader_enabled = true
}
