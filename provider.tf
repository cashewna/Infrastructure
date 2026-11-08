provider "oci" {
  tenancy_ocid     = var.tenancy
  user_ocid        = var.user
  private_key_path = pathexpand(var.private_key_path)
  fingerprint      = var.fingerprint
  region           = var.region
}
