locals {
  # Prefer an explicitly supplied compartment, then one this configuration
  # creates, then the tenancy root. The created compartment is optional because
  # a scoped operator cannot create compartments.
  compartment_id = coalesce(
    var.compartment,
    try(oci_identity_compartment.tf-compartment[0].id, null),
    var.tenancy,
  )
}
