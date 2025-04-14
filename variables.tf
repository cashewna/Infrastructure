variable "tenancy" {
  description = "The OCID of the tenancy"
  type        = string
}

variable "user" {
  description = "The OCID of the user"
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint of the user"
  type        = string
}

variable "compartment" {
  description = "The OCID of the OpenTofu compartment"
  type        = string
}

variable "subnet" {
  description = "The OCID of the public subnet"
  type        = string
}