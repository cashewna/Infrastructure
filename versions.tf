terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "~> 6.34"
    }
  }
  required_version = ">= 1.6.0"
}
