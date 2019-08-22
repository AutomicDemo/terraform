variable "project" {default = "demos-esd-automation"}
variable "region" {default = "us-east1"}
variable "subnetwork" {default = "default"}
variable "image" {default = "centos-7-v20190813"}
variable "infrastructure_name" {default = "dev"}
variable "credentials" {}
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

  metadata = {
    ssh-keys = "AutomicDemo:ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDsQ8B6G+bBbYa9o5p2g0QwhPhxm0dmssmUISas7HakO61EV+tiBGQ32AX2uwFqDXutg3x9Xb0iATFUtBWGGKnYVGnw60YyHFW2TtCHB7xoU96BH9cg+BJRcrNFz2t7hoYs5gyRyJTH7xFbjVKAZbcPGS+vJPJvwEr4QQChaXowWZ+YNB+BTcEuLADH7AmPCpweqo1QlCRGIWTzvu4I9fCqUKeu/TRfgQYORT9EycL0TGqy8FkUByoTC4FRD754GRn0+ddF7zAB9EuVE+9LzWEDSkKiBJhvtdTdBN9hRm7gjIKOjYPPrIijfRwbrqxsy25w5hyUPKfZNhmatiGLaEmt AutomicDemo"
  }	
  
  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }
  service_account {
      email     = "2348479185-compute@developer.gserviceaccount.com"
      scopes    = ["cloud-platform"]
	  }
	
  network_interface {
    subnetwork = "${var.subnetwork}"
    subnetwork_project = "${var.project}"
  }
}
  


