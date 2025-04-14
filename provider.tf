provider "oci" {
  tenancy_ocid     = var.tenancy
  user_ocid        = var.user
  private_key_path = "~/.oci/rsa.pem"
  fingerprint      = var.fingerprint
  region           = "ap-sydney-1"
}
