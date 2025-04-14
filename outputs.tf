output "all-availability-domains-in-your-tenancy" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

output "compartment-name" {
  value = oci_identity_compartment.tf-compartment.name
}

output "compartment-id" {
  value = oci_identity_compartment.tf-compartment.id
}