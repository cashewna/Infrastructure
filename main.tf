locals {
  # Use an existing compartment when one is given, otherwise the compartment this
  # configuration creates. Using the created compartment directly removes the
  # chicken-and-egg of having to know its OCID before the first apply.
  compartment_id = coalesce(var.compartment, oci_identity_compartment.tf-compartment.id)
}
