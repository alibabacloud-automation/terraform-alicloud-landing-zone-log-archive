provider "alicloud" {
  alias  = "management_account"
  region = "cn-hangzhou"
}

# assume role to logarchive account
provider "alicloud" {
  alias  = "log_archive_account"
  region = "cn-hangzhou"
  assume_role {
    role_arn           = format("acs:ram::%s:role/ResourceDirectoryAccountAccessRole", var.log_archive_account_id)
    session_name       = "LandingZoneLogAudit"
    session_expiration = 3600
  }
}

resource "random_string" "random" {
  length  = 8
  special = false
  upper   = false
}

module "log_archive" {
  source = "../../"

  providers = {
    alicloud.management_account  = alicloud.management_account
    alicloud.log_archive_account = alicloud.log_archive_account
  }

  log_audit_display_name = format("landingzone-log-audit-%s", random_string.random.result)
  log_audit_config = {
    oss_access_enabled    = "true"
    rds_enabled           = "true"
    cloudfirewall_enabled = "true"
    k8s_audit_enabled     = "true"
  }
}
