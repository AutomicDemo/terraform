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
    ssh-keys = "mike:ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAiKq6YB5jGX+rhbBkZF6Z2G+AEf5f6eedwHulIrvRwlkzjo+jD3WmZOffKG9wnh13AoNegRwHuliIdJGVlyCSr7Kse/xj7lwOOle4kHiqv7QlYKr1EkHJIxffTqw8jqBQ5RMRNQFxVliGuvNx0g2p8rf5pkU+1G3lDWkkNjFlbi2A+WhlELoQ3uNGkR6SWtgqdpEhB6d8pelBFWFFEvVsls/PpCnxZORIIPpcQ1pyXvP9xALLJXRdQTOG1DY6dcl766S4Nn/MWZkhh+q9mbsvGl8P5pzuWKMmWl+mySR9nH7q5SxyPtnlHWnRaQ/w8Pa9o0tTDqD4k9jR5loJvRPL+Q== mike"
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
  


