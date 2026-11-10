# Hard ceilings: the quota is enforced at provisioning time, so a leaked key or
# a mistaken plan cannot create billable compute or storage. Quotas take up to
# 10 minutes to become active.
resource "oci_limits_quota" "always_free" {
  compartment_id = var.tenancy
  name           = "always-free-caps"
  description    = "Always Free Arm: 2 OCPU / 12 GB, 200 GB block storage, 5 backups"

  statements = [
    "zero compute-core quotas in tenancy",
    "zero compute-memory quotas in tenancy",
    "set compute-core quota standard-a1-core-count to 2 in tenancy",
    "set compute-memory quota standard-a1-memory-count to 12 in tenancy",
    "set block-storage quota total-storage-gb to 200 in tenancy",
    "set block-storage quota backup-count to 5 in tenancy",
  ]
}

# Budgets only notify; the quota above is the hard stop.
resource "oci_budget_budget" "always_free" {
  compartment_id = var.tenancy
  display_name   = "always-free-alert"
  description    = "Alert on any spend above the Always Free allowance"
  amount         = var.budget_amount_aud
  reset_period   = "MONTHLY"
  target_type    = "COMPARTMENT"
  targets        = [var.tenancy]
}

resource "oci_budget_alert_rule" "half" {
  budget_id      = oci_budget_budget.always_free.id
  display_name   = "50-percent"
  threshold      = 50
  threshold_type = "PERCENTAGE"
  type           = "ACTUAL"
  recipients     = var.alert_email
  message        = "OCI spend has reached 50% of the monthly budget."
}

resource "oci_budget_alert_rule" "full" {
  budget_id      = oci_budget_budget.always_free.id
  display_name   = "100-percent"
  threshold      = 100
  threshold_type = "PERCENTAGE"
  type           = "ACTUAL"
  recipients     = var.alert_email
  message        = "OCI spend has reached 100% of the monthly budget."
}
