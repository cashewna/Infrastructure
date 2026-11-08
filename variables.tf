variable "tenancy" {
  description = "The OCID of the tenancy (root compartment)."
  type        = string
}

variable "user" {
  description = "The OCID of the user whose API signing key is used."
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint of the API signing key for the user."
  type        = string
}

variable "private_key_path" {
  description = "Path to the API signing private key."
  type        = string
  default     = "~/.oci/rsa.pem"
}

variable "region" {
  description = "OCI region identifier. Always Free compute must live in the tenancy's home region."
  type        = string
  default     = "ap-sydney-1"
}

variable "compartment" {
  description = "The OCID of an existing compartment. Null uses the compartment created by this configuration."
  type        = string
  default     = null
}

variable "subnet" {
  description = "The OCID of the public subnet."
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key installed for the image's default user (ubuntu)."
  type        = string
}

variable "instance_name" {
  description = "Display name of the instance."
  type        = string
  default     = "bee"
}

variable "availability_domain" {
  description = "Availability domain name. Null uses the first AD returned for the tenancy."
  type        = string
  default     = null
}

variable "shape" {
  description = "Compute shape. VM.Standard.A1.Flex is the Always Free Arm shape."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "ocpus" {
  description = "OCPUs allocated to the instance. Always Free Arm allows 2 in total across all instances."
  type        = number
  default     = 2

  validation {
    condition     = var.ocpus > 0 && var.ocpus <= 2
    error_message = "An Always Free Arm tenancy is limited to 2 OCPUs in total. Edit this validation if you move to Pay As You Go."
  }
}

variable "memory_in_gbs" {
  description = "Memory allocated to the instance. Always Free Arm allows 12 GB in total across all instances."
  type        = number
  default     = 12

  validation {
    condition     = var.memory_in_gbs > 0 && var.memory_in_gbs <= 12
    error_message = "An Always Free Arm tenancy is limited to 12 GB of memory in total. Edit this validation if you move to Pay As You Go."
  }
}

variable "boot_volume_gb" {
  description = "Boot volume size in GB. The whole Always Free block storage allowance is 200 GB, boot volumes included."
  type        = number
  default     = 200

  validation {
    condition     = var.boot_volume_gb >= 50 && var.boot_volume_gb <= 200
    error_message = "OCI requires at least 50 GB for a boot volume, and Always Free only covers 200 GB of block storage."
  }
}

variable "ubuntu_version" {
  description = "Canonical Ubuntu release used to select the platform image."
  type        = string
  default     = "24.04"
}
