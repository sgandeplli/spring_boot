# Google Cloud Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create the Google Kubernetes Engine (GKE) cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region  # Use the region you specified

  deletion_protection = false

  initial_node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 30
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

# Output the GKE cluster endpoint and CA certificate for debugging
output "gke_cluster_endpoint" {
  value = data.google_container_cluster.primary.endpoint
}

output "gke_cluster_ca_certificate" {
  value = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

# Configure the Kubernetes provider (using the existing google provider)
provider "kubernetes" {
  host                   = data.google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token  # Correct token retrieval
}

# Configure the Helm provider (explicitly reference the kubernetes provider)
provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token  # Correct token retrieval
  }
}

# Delegate Module Configuration
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

# Define the input variables for the project
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "decoded-plane-452604-r7"
}

variable "region" {
  description = "The region where the resources will be created"
  type        = string
  default     = "us-west3-c"  # Use the region specified in your input
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  default     = "my-cluster11"  # Default name of the cluster
}

variable "node_count" {
  description = "The number of nodes in the Kubernetes cluster"
  type        = number
  default     = 1  # Number of nodes in the cluster
}

variable "node_machine_type" {
  description = "The type of machine to use for nodes in the Kubernetes cluster"
  type        = string
  default     = "e2-medium"  # Machine type for the nodes
}
# Google Cloud Provider Configuration
provider "google" {
  project = var.project_id
  region  = var.region
}

# Create the Google Kubernetes Engine (GKE) cluster
resource "google_container_cluster" "primary" {
  name     = var.cluster_name
  location = var.region  # Use the region you specified

  deletion_protection = false

  initial_node_count = var.node_count

  node_config {
    machine_type = var.node_machine_type
    disk_size_gb = 30
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

# Output the GKE cluster endpoint and CA certificate for debugging
output "gke_cluster_endpoint" {
  value = data.google_container_cluster.primary.endpoint
}

output "gke_cluster_ca_certificate" {
  value = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
}

# Configure the Kubernetes provider (using the existing google provider)
provider "kubernetes" {
  host                   = data.google_container_cluster.primary.endpoint
  cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
  token                  = data.google_client_config.default.access_token  # Correct token retrieval
}

# Configure the Helm provider (explicitly reference the kubernetes provider)
provider "helm" {
  kubernetes {
    host                   = data.google_container_cluster.primary.endpoint
    cluster_ca_certificate = base64decode(data.google_container_cluster.primary.master_auth[0].cluster_ca_certificate)
    token                  = data.google_client_config.default.access_token  # Correct token retrieval
  }
}

# Delegate Module Configuration
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

# Define the input variables for the project
variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "decoded-plane-452604-r7"
}

variable "region" {
  description = "The region where the resources will be created"
  type        = string
  default     = "us-west3-c"  # Use the region specified in your input
}

variable "cluster_name" {
  description = "The name of the Kubernetes cluster"
  type        = string
  default     = "my-cluster11"  # Default name of the cluster
}

variable "node_count" {
  description = "The number of nodes in the Kubernetes cluster"
  type        = number
  default     = 1  # Number of nodes in the cluster
}

variable "node_machine_type" {
  description = "The type of machine to use for nodes in the Kubernetes cluster"
  type        = string
  default     = "e2-medium"  # Machine type for the nodes
}
