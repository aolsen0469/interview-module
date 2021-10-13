terraform {
  required_version = ">= 0.12"

  backend "gcs" {
    bucket = ""
    prefix = "techops/interview"
  }

}

provider google {
  region  = var.region
  zone    = var.region
  project = ""
}

# ---------------------------------------------------------------------------------------------------------------------
# Service Account 
# ---------------------------------------------------------------------------------------------------------------------

# Service Account
resource "google_service_account" "svc_account" {
  account_id   = var.svc_account
  display_name = "Service Account that only the candidate will interact with" 
  project      = var.project_id
}


# ---------------------------------------------------------------------------------------------------------------------
# IAM Policy
# ---------------------------------------------------------------------------------------------------------------------
resource "google_project_iam_member" "kubernetes-admin" {
  project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.svc_account.email}"
}

resource "google_project_iam_member" "project-editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.svc_account.email}"
}

# ---------------------------------------------------------------------------------------------------------------------
# NETWORKING 
# ---------------------------------------------------------------------------------------------------------------------
resource "google_compute_address" "static-ip-bastion" {
  name = "interview-bastion-host"
  region = "northamerica-northeast1"
}

resource "google_compute_address" "static-ip-ingress" {
  name = "interview-ingress-ip"
  region = "northamerica-northeast1"
}

resource "google_compute_address" "static-ip-ingress-jenkins" {
  name = "interview-ingress-jenkins-ip"
  region = "northamerica-northeast1"
}

resource "google_dns_record_set" "dns" {
  name         = "techops-interview.bar.foo.com."
  project      = var.dns_project_id
  type         = "A"
  ttl          = 300
  managed_zone = "dev-zone"
  rrdatas      = ["${google_compute_address.static-ip-ingress.address}"]
}

resource "google_dns_record_set" "dns-bastion" {
  name         = "techops-interview-vm.foo.bar.com."
  project      = var.dns_project_id
  type         = "A"
  ttl          = 300
  managed_zone = "dev-zone"
  rrdatas      = ["${google_compute_address.static-ip-bastion.address}"]
}



# ---------------------------------------------------------------------------------------------------------------------
# BASTION HOST 
# ---------------------------------------------------------------------------------------------------------------------

resource "null_resource" "deploy_module" {
  provisioner "local-exec" {
    command = "bash deploy-k8s-rails-todo-list.sh"
  }
# wait until cluster is created and compute instance is created to apply kubectl
  depends_on = [
   google_container_cluster.primary,
  ]
}


resource "google_compute_instance" "default" {
  name         = "techops-interview-bastion"
  machine_type = "e2-small"
  zone         = var.region 

  allow_stopping_for_update = true
  tags = ["ssh"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
    network = "default"

    access_config {
      nat_ip = google_compute_address.static-ip-bastion.address
    }
  }

  metadata = {
    enable-oslogin = "FALSE"
     ssh-keys = var.ssh_keys2
  }

  metadata_startup_script = file("${path.module}/setup.sh")

  service_account {
    email  = google_service_account.svc_account.email
    scopes = ["cloud-platform"]
  }


# Provision 'interview' user with the broken kubernetes manifests in his home directory
provisioner "file" {
  source = var.source-troubleshooting-module 
  destination = var.destination-troubleshooting-module 

  connection {
    type = "ssh"
    timeout = "2m" # The timeout to wait for the connection to become available
    user = "interview"
    host = google_compute_address.static-ip-bastion.address
    private_key = "${file("../ssh/interview")}"
    agent = "false"
  }
}


provisioner "file" {
  source = var.source-devops-troubleshooting-module
  destination = var.destination-devops-troubleshooting-module

  connection {
    type = "ssh"
    timeout = "2m" # The timeout to wait for the connection to become available
    user = "devops-interview"
    host = google_compute_address.static-ip-bastion.address
    private_key = "${file("../ssh/interview")}"
    agent = "false"
  }
}

  depends_on = [
   null_resource.deploy_module,
  ]

}



# ---------------------------------------------------------------------------------------------------------------------
# OUTPUTS
# ---------------------------------------------------------------------------------------------------------------------

output "bastion_ip" {
  value = google_compute_address.static-ip-bastion.address
}

output "website_addr" {
  value = google_dns_record_set.dns.name
}

output "LoadBalancerIP" { 
  value = google_compute_address.static-ip-ingress.address
}

