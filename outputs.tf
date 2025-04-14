output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.tf-compartment.name
}

output "compartment-id" {
  value = oci_identity_compartment.tf-compartment.id
}

output "public-ip-for-compute-instance" {
  value = oci_core_instance.ubuntu_arm_instance.public_ip
}

output "instance-name" {
  value = oci_core_instance.ubuntu_arm_instance.display_name
}

output "instance-OCID" {
  value = oci_core_instance.ubuntu_arm_instance.id
}

output "instance-region" {
  value = oci_core_instance.ubuntu_arm_instance.region
}

output "instance-shape" {
  value = oci_core_instance.ubuntu_arm_instance.shape
}

output "instance-state" {
  value = oci_core_instance.ubuntu_arm_instance.state
}

output "instance-OCPUs" {
  value = oci_core_instance.ubuntu_arm_instance.shape_config[0].ocpus
}

output "instance-memory-in-GBs" {
  value = oci_core_instance.ubuntu_arm_instance.shape_config[0].memory_in_gbs
}

output "time-created" {
  value = oci_core_instance.ubuntu_arm_instance.time_created
}