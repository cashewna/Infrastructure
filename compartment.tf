resource "oci_identity_compartment" "tf-compartment" {
  compartment_id = var.tenancy
  description    = "Compartment for OpenTofu resources"
  name           = "OpenTofu"
}
