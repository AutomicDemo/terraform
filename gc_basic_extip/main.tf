variable "project" {default = "demos-esd-automation"}
variable "region" {default = "us-east1"}
variable "subnetwork" {default = "default"}
variable "image" {default = "projects/demos-esd-automation/global/images/centos-demo-default-v2"}
variable "infrastructure_name" {default = "demo"}
variable "credentials" {}
variable "zone" {default = "us-east1-c"}
variable "machine_type" {default = "f1-micro"}
variable "override" {}
variable "email" {default = "2348479185-compute@developer.gserviceaccount.com"}
variable "ssh_user" {default = "automic"}
variable "public_key" {default = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAgF8m+KDKerDYe0xoj9042H8DqM7T1Qil0+QxUXTcxLpO/in3wqpphlyVsuGRjFvkeHVCezimMtk6YWW2e2gNv7ugKfj1AoBhwxkcvcEQtCf67RFlGBYMZlzLOXItvAaU2c8eqnTn5lvY14vosNkj4ACVXZJDhNWs3qLLSrEuN3xUsuDgQVE4aNiwfTKYAVahSCFBueL26Zq4tcZaZmfC23YRGOaCvjFeShKqHcQl1nihcHB421oHOGRaZIc4Fwzf6TsRF9+OAA0MLEKIm17VtF6pfxt5rn3sxeVhfBulScH2uhApoB52yY1eDYCQQXmV5uYg8DoTNTFemGQMDHt/2Q== automic"}


variable "num_nodes" {
  description = "Number of nodes to create"
  default     = 1
}

locals {
	id = "${random_integer.name_extension.result}"
}

resource "google_compute_address" "external_ip" {
  name         = "${var.override}"
  subnetwork   = "${var.subnetwork}"
  address_type = "EXTERNAL"
  region       = ""${var.region}"
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
  machine_type = "${var.machine_type}"
  metadata = {
    ssh-keys = "${var.ssh_user}:${(var.public_key)}"
  }
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
    access_config {
      nat_ip = "${google_compute_address.external_ip.address}"
    }
  }
}
