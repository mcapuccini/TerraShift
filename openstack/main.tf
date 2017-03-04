# Cluster settings
variable cluster_prefix { default="openshift" }
variable ssh_key { default = "~/.ssh/id_rsa.pub" }
variable external_network_uuid {}
variable dns_nameservers { default="8.8.8.8,8.8.4.4" }
variable floating_ip_pool {}

# Nodes settings
variable base_image {}
variable node_count { default = "2" }
variable node_flavor {}
variable node_flavor_id { default = "" }

# Upload ssh-key to be used for access to the nodes
module "keypair" {
  source = "./keypair"
  public_key = "${var.ssh_key}"
  name_prefix = "${var.cluster_prefix}"
}

# Create a network (and security group) with an externally attached router
module "network" {
  source = "./network"
  external_net_uuid = "${var.external_network_uuid}"
  name_prefix = "${var.cluster_prefix}"
  dns_nameservers = "${var.dns_nameservers}"
}

# Create nodes
module "node" {
  source = "./node"
  name_prefix = "${var.cluster_prefix}"
  image_name = "${var.base_image}"
  flavor_name = "${var.node_flavor}"
  flavor_id = "${var.node_flavor_id}"
  keypair_name = "${module.keypair.keypair_name}"
  network_name = "${module.network.network_name}"
  secgroup_name = "${module.network.secgroup_name}"
  floating_ip_pool = "${var.floating_ip_pool}"
  count = "${var.node_count}"
}
