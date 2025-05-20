provider "google" {
  credentials = file("gcp-key.json")
  project     = var.project_id
  region      = var.region
  zone        = var.zone
}

resource "google_compute_network" "default" {
  name                    = "default-network"
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "default" {
  name    = "default-allow-ssh-api"
  network = google_compute_network.default.name

  allow {
    protocol = "tcp"
    ports    = ["22", "3000"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_instance" "vm_instance" {
  name         = "api-vm"
  machine_type = "e2-medium"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = google_compute_network.default.name
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${file(var.public_key_path)}"
  }

  tags = ["http-server", "https-server"]
}
