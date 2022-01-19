
################
#VMs
################

# creating CentOS 8 instance
resource "openstack_compute_instance_v2" "CentOS8" {
  name = "terraform_CentOS8"
  # ID of JS-API-Featured-CentOS8-Latest
  image_id  = "006c8d04-1966-4706-b67c-5ae532d66683"
  flavor_id   = 3
  # this public key is set in security.tf
  key_pair  = "wellsaar"
  security_groups   = ["terraform_ssh_ping", "default"]

  metadata = {
    terraform_controlled = "yes"
  }
  network {
    name = "terraform_network"
  }
}
# creating floating ip from the public ip pool
resource "openstack_networking_floatingip_v2" "terraform_floatip" {
  pool = "public"
}

# assigning floating ip from public pool to CentOS 8 VM
resource "openstack_compute_floatingip_associate_v2" "terraform_floatcentos8" {
  floating_ip = "${openstack_networking_floatingip_v2.terraform_floatip.address}"
  instance_id = "${openstack_compute_instance_v2.CentOS8.id}"
}

################
#Output
################

output "floating_ip_centos8" {
  value = openstack_networking_floatingip_v2.terraform_floatip.address
  description = "Public IP for CentOS 8"
}
