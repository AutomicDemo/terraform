variable "project" {default = "demos-esd-automation"}
variable "region" {default = "us-east1"}
variable "subnetwork" {default = "default"}
variable "image" {default = "debian-9-tf-1-14-1-dev20190508-v20190816"}
variable "infrastructure_name" {default = "Dev"}
variable "credentials"{}
variable "zone" {default = "us-east1-c"}

variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "random_integer" "name_extension" {
  min     = 1
  max     = 99999
}

provider "google" {
  credentials = "${var.credentials}"
  project     = "${var.project}"
  region      = "${var.region}"
}

resource "google_compute_instance" "default" {
  count        = "${var.num_nodes}"
  project      = "${var.project}"
  zone         = "${var.zone}"
  name         = "${var.infrastructure_name}-${count.index + 1}-${local.id}"
  machine_type = "f1-micro"
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  service_account {
      email     = "2348479185-compute@developer.gserviceaccount.com"
	  }
	
  network_interface {
    subnetwork = "${var.subnetwork}"
    subnetwork_project = "${var.project}"
  }
}
  


