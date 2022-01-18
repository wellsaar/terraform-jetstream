################
#Security section
################
#creating security group
resource "openstack_compute_secgroup_v2" "terraform_ssh_ping" {
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
#Networking
################
#creating the virtual network
resource "openstack_networking_network_v2" "terraform_network" {
  name = "terraform_network"
  admin_state_up  = "true"
}

#creating the virtual subnet
resource "openstack_networking_subnet_v2" "terraform_subnet1" {
  name = "terraform_subnet1"
  network_id  = "${openstack_networking_network_v2.terraform_network.id}"
  cidr  = "192.168.0.0/24"
  ip_version  = 4
}
# setting up virtual router
resource "openstack_networking_router_v2" "terraform_router" {
  name = "terraform_router"
  admin_state_up  = true
  # id of public network at IU
  external_network_id = "4367cd20-722f-4dc2-97e8-90d98c25f12e"
}
# setting up virtual router interface
resource "openstack_networking_router_interface_v2" "terraform_router_interface_1" {
  router_id = "${openstack_networking_router_v2.terraform_router.id}"
  subnet_id = "${openstack_networking_subnet_v2.terraform_subnet1.id}"
}


#
# # creating Ubuntu20 instance
# resource "openstack_compute_instance_v2" "Ubuntu20" {
#   name = "terraform-Ubuntu20"
#   image_id = "8f27559a-9e63-4fb7-9704-09526793e2d2"
#
#
# }
