data "oci_core_images" "ubuntu_arm" {
  compartment_id           = var.tenancy
  operating_system         = "Canonical Ubuntu"
  operating_system_version = var.ubuntu_version
  shape                    = var.shape
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

resource "oci_core_instance" "ubuntu_arm_instance" {
  availability_domain = coalesce(var.availability_domain, data.oci_identity_availability_domains.ads.availability_domains[0].name)
  compartment_id      = local.compartment_id
  shape               = var.shape
  display_name        = var.instance_name

  shape_config {
    ocpus         = var.ocpus
    memory_in_gbs = var.memory_in_gbs
  }

  source_details {
    source_id               = data.oci_core_images.ubuntu_arm.images[0].id
    source_type             = "image"
    boot_volume_size_in_gbs = var.boot_volume_gb
  }

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet
    nsg_ids          = [oci_core_network_security_group.bee.id]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_public_key
  }

  # The boot volume holds the Minecraft world. The quota below prevents a
  # replacement from silently creating a second 200 GB volume: apply fails
  # until the preserved volume is deleted.
  preserve_boot_volume                    = true
  preserve_data_volumes_created_at_launch = true

  freeform_tags = {
    managed-by = "opentofu"
    purpose    = "always-free-arm"
  }

  lifecycle {
    # Create-time or immutable on an existing instance: keep it as launched
    # rather than planning a replacement or an update OCI will reject.
    ignore_changes = [
      availability_domain,
      source_details[0].source_id,
      metadata["ssh_authorized_keys"],
      launch_volume_attachments,
    ]
  }
}
