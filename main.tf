provider "google" {
  project = "poc-danamon-devsecops"
  region  = "asia-southeast2"
}

resource "google_compute_firewall" "tunnel" {
  name    = "allow-tunnel"
  network = "default"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_instance" "tunnel" {
  name          = "tunnel-instance"
  machine_type  = "f1-micro"
  zone          = "asia-southeast2-a"
  
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-lts"
    }
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }
  
  tags = ["ssh", "test"]
}

output "public_ip" {
  value = "${google_compute_instance.tunnel.network_interface.0.access_config.0.nat_ip}"
}
