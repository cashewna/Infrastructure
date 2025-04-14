resource "oci_core_instance" "ubuntu_arm_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment
  shape               = "VM.Standard.A1.Flex"
  display_name = "bee"

  shape_config {
    ocpus         = "4"
    memory_in_gbs = "24"
  }

  // Image of computer instance
  source_details {
    source_id   = "ocid1.image.oc1.ap-sydney-1.aaaaaaaal3xpx42qvcgpz72tbrkgf25xe6w2ii73rppdpykajx4gbfotdjla"
    source_type = "image"
  }
  
  create_vnic_details {
    assign_public_ip = true
    subnet_id        = var.subnet
  }

  metadata = {
    ssh_authorized_keys = file("~/.ssh/oracle.pub")
  }


  launch_volume_attachments {
    type = "paravirtualized"

    launch_create_volume_details {
      size_in_gbs = "200"
      volume_creation_type = "ATTRIBUTES"
    }
  }

  preserve_boot_volume = false
}
