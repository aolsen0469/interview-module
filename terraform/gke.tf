

# ---------------------------------------------------------------------------------------------------------------------
# GKE Cluster
# ---------------------------------------------------------------------------------------------------------------------

resource "google_container_cluster" "primary" {
  name     = var.clustername
  location = var.region
  remove_default_node_pool = true
  initial_node_count       = 1
  master_authorized_networks_config {
    cidr_blocks {
      cidr_block   = "${google_compute_address.static-ip-bastion.address}/32"
      display_name = "interview-vm"
    }
    cidr_blocks {
      cidr_block   = var.auth-office-cidr
      display_name = "office"
    }
    cidr_blocks {
      cidr_block   = var.auth-vpn-cidr
      display_name = "vpn"
    }
  }
}

resource "google_container_node_pool" "app-pool" {
  name       = "app-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    taint {
      key    = "app-pool"
      value  = "true"
      effect = "NO_SCHEDULE"
     }
    preemptible  = false
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.svc_account.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "data-pool" {
  name       = "data-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1

  node_config {
    taint {
      key    = "data-pool"
      value  = "true"
      effect = "NO_SCHEDULE"
     }
    preemptible  = false
    machine_type = "e2-medium"

    service_account = google_service_account.svc_account.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

resource "google_container_node_pool" "default-pool" {
  name       = "default-pool"
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = 1
  node_config {
    preemptible  = false
    machine_type = "e2-medium"

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    service_account = google_service_account.svc_account.email
    oauth_scopes    = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}

