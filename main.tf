resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region  # This is still the region, like 'us-central1'

  deletion_protection = false

  initial_node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 30
    # Adding zone here for node pool creation
  }

  remove_default_node_pool = false
}

# Retrieve the GKE cluster info
data "google_container_cluster" "primary" {
  name     = google_container_cluster.primary.name
  location = google_container_cluster.primary.location
}

# Retrieve the client config for Google Cloud (used for access token)
data "google_client_config" "default" {}

# Configure the Kubernetes provider
provider "kubernetes" {
  host                   = data.google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token
}

# Configure the Helm provider
provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token
  }
}
