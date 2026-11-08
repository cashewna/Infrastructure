output "instance_id" {
  value = oci_core_instance.ubuntu_arm_instance.id
}

output "instance_name" {
  value = oci_core_instance.ubuntu_arm_instance.display_name
}

output "public_ip" {
  value = oci_core_instance.ubuntu_arm_instance.public_ip
}

output "region" {
  value = oci_core_instance.ubuntu_arm_instance.region
}

output "availability_domain" {
  value = oci_core_instance.ubuntu_arm_instance.availability_domain
}

output "shape" {
  value = oci_core_instance.ubuntu_arm_instance.shape
}

output "ocpus" {
  value = oci_core_instance.ubuntu_arm_instance.shape_config[0].ocpus
}

output "memory_in_gbs" {
  value = oci_core_instance.ubuntu_arm_instance.shape_config[0].memory_in_gbs
}

output "boot_volume_gb" {
  value = oci_core_instance.ubuntu_arm_instance.source_details[0].boot_volume_size_in_gbs
}

output "compartment_id" {
  value = local.compartment_id
}
