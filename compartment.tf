resource "oci_identity_compartment" "tf-compartment" {
  count          = var.create_compartment ? 1 : 0
  compartment_id = var.tenancy
  description    = "Compartment for OpenTofu resources"
  name           = "OpenTofu"
}
