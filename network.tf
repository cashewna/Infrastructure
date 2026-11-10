data "oci_core_subnet" "this" {
  subnet_id = var.subnet
}

resource "oci_core_network_security_group" "bee" {
  compartment_id = local.compartment_id
  vcn_id         = data.oci_core_subnet.this.vcn_id
  display_name   = "${var.instance_name}-nsg"
}

resource "oci_core_network_security_group_security_rule" "ssh" {
  network_security_group_id = oci_core_network_security_group.bee.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "SSH"

  tcp_options {
    destination_port_range {
      min = 22
      max = 22
    }
  }
}

resource "oci_core_network_security_group_security_rule" "minecraft" {
  network_security_group_id = oci_core_network_security_group.bee.id
  direction                 = "INGRESS"
  protocol                  = "6"
  source                    = "0.0.0.0/0"
  source_type               = "CIDR_BLOCK"
  description               = "Minecraft"

  tcp_options {
    destination_port_range {
      min = 25565
      max = 25565
    }
  }
}

resource "oci_core_network_security_group_security_rule" "egress" {
  network_security_group_id = oci_core_network_security_group.bee.id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
  description               = "All outbound"
}
