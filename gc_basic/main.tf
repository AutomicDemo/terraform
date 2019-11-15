variable "project" {default = "demos-esd-automation"}
variable "region" {default = "us-east1"}
variable "subnetwork" {default = "default"}
variable "image" {default = "projects/demos-esd-automation/global/images/centos-demo-default-v2"}
variable "infrastructure_name" {default = "demo"}
variable "credentials" {}
variable "zone" {default = "us-east1-c"}
variable "override" {}
variable "email" {default = "1088214523720-compute@developer.gserviceaccount.com"}


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
  name         = "${var.override}"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  service_account {
      email     = "${var.email}"
      scopes    = ["cloud-platform"]
	  }
	
  network_interface {
    subnetwork = "${var.subnetwork}"
    subnetwork_project = "${var.project}"
  }
}
  


