################
#Security section
################
#creating security group
resource "openstack_compute_secgroup_v2" "terraform_ssh_ping_centos" {
  name = "terraform_ssh_ping"
  description = "Security group with SSH and PING open to 0.0.0.0/0"

  #ssh rule
  rule{
    ip_protocol = "tcp"
    from_port  =  "22"
    to_port    =  "22"
    cidr       = "0.0.0.0/0"
  }
  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

}
# #public key that will be installed in the .authorized_keys file on the vm
# resource "openstack_compute_keypair_v2" "keypair" {
#   name       = "my_public_key"
#   # you will need to paste your public key string here
#   public_key = ""
# }


################
#VMs
################

# creating Ubuntu20 instance
resource "openstack_compute_instance_v2" "CentOS8" {
  name = "terraform_Ubuntu20"
  # ID of JS-API-Featured-CentOS8-Latest
  image_id  = "006c8d04-1966-4706-b67c-5ae532d66683"
  flavor_id   = 3
  # this public key is set above in security section
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

# assigning floating ip from public pool to Ubuntu20 VM
resource "openstack_compute_floatingip_associate_v2" "terraform_floatcentos8" {
  floating_ip = "${openstack_networking_floatingip_v2.terraform_floatip.address}"
  instance_id = "${openstack_compute_instance_v2.Ubuntu20.id}"
}

################
#Output
################


output "floating_ip_centos8" {
  value = openstack_networking_floatingip_v2.terraform_floatip.address
  description = "Public IP for Ubuntu 20"
}
