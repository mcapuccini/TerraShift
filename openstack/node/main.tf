variable name_prefix {}
variable image_name {}
variable flavor_name {}
variable flavor_id {}
variable keypair_name {}
variable network_name {}
variable floating_ip_pool {}
variable count {}
variable secgroup_name {}

# Allocate floating IPs
resource "openstack_compute_floatingip_v2" "node_ip" {
  pool = "${var.floating_ip_pool}"
  count = "${var.count}"
}

# Create instances
resource "openstack_compute_instance_v2" "node" {
  count = "${var.count}"
  name="${var.name_prefix}-node-${format("%02d", count.index)}"
  image_name = "${var.image_name}"
  flavor_name = "${var.flavor_name}"
  flavor_id = "${var.flavor_id}"
  key_pair = "${var.keypair_name}"
  floating_ip = "${element(openstack_compute_floatingip_v2.node_ip.*.address, count.index)}"
  network {
    name = "${var.network_name}"
  }
  security_groups = ["${var.secgroup_name}"]
}

# Generate ansible inventory
#resource "null_resource" "generate-inventory" {
#
#  provisioner "local-exec" {
#    command =  "echo \"[node]\" >> inventory"
#  }
#
#  provisioner "local-exec" {
#    command =  "echo \"${join("\n",formatlist("%s ansible_ssh_host=%s ansible_ssh_user=ubuntu", openstack_compute_instance_v2.node.*.name, openstack_compute_floatingip_v2.node_ip.*.address))}\" >> inventory"
#  }
#
#  provisioner "local-exec" {
#    command =  "echo \"[master:vars]\" >> inventory"
#  }
#
#  provisioner "local-exec" {
#    command =  "echo 'node_names=\"${lower(join(" ",formatlist("%s", openstack_compute_instance_v2.node.*.name)))}\"' >> inventory"
#  }
#
#}
