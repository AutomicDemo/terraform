variable "vsphere_user" {default =""}
variable "vsphere_password" {default =""}
variable "vsphere_server" {default = "vvievc01.sbb01.spoc.global"}
variable "private_key" {default =""}
variable "ubuntu_password" {defauld =""}

provider "vsphere" {
  user           = "${var.vsphere_user}"
  password       = "${var.vsphere_password}"
  vsphere_server = "${var.vsphere_server}"
  
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "Test"
}

data "vsphere_datastore" "datastore" {
  name          = "extvimDatastorcluster/local Storage svievmw04"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_compute_cluster" "cluster" {
  name          = "Testcluster"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "VM Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "ubuntu-template"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "terraform-test"
  resource_pool_id = "${data.vsphere_compute_cluster.cluster.resource_pool_id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder           = "em"

  num_cpus = 2
  memory   = 16384
  wait_for_guest_net_timeout = 0
  guest_id = "${data.vsphere_virtual_machine.template.guest_id}"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size  = 150
    thin_provisioned = true
  }
  
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
  }
	
  provisioner "remote-exec" {
	inline = [
		"mkdir -p /home/ubuntu/AE"
	]
		
	connection {
		type        = "ssh"
		user        = "automic"
		password    = "${var.ubuntu_password}"
	}
  }
	
  provisioner "file" {
	source      = "./artifacts"
	destination = "/home/ubuntu/AE"
		
	connection {
		type        = "ssh"
		user        = "ubuntu"
		private_key = "${file("./nguta04.pem")}"
	}
 }
	
 provisioner "file" {
	source      = "./install_agent_servicemanager.sh"
	destination = "/home/ubuntu/AE/install_agent_servicemanager.sh"
	
	connection {
		type        = "ssh"
		user        = "ubuntu"
		private_key = "${file("./nguta04.pem")}"
	}
 }
	
 provisioner "remote-exec" {
	inline = [
		"chmod +x /home/ubuntu/AE/install_agent_servicemanager.sh",
		"/home/ubuntu/AE/install_agent_servicemanager.sh ${var.agent_name} ${var.ae_host} ${var.ae_port} ${var.sm_port}"
	]
		
	connection {
		type        = "ssh"
		user        = "ubuntu"
		private_key = "${file("./nguta04.pem")}"
	}
 }
}
