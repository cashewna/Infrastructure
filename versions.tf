terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">=6.34.0"
    }
  }
  required_version = ">= 1.0.0"
}