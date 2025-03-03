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
    oss_access_ttl        = "7"
    rds_enabled           = "true"
    rds_ttl               = "180"
    cloudfirewall_enabled = "true"
    cloudfirewall_ttl     = "180"
    k8s_audit_enabled     = "true"
    k8s_audit_ttl         = "180"
  }
  enabled_control_policy     = true
  control_policy_name        = "ProhibitDeleteLogAudit"
  control_policy_description = "Prohibit to delete resources for log archiving and auditing."
}

# cold archive to oss（optional）
module "cold_archive_to_oss" {
  source = "../../modules/cold-archive-to-oss"
  providers = {
    alicloud = alicloud.log_archive_account
  }

  project_name           = module.log_archive.log_archive_project_name
  use_existed_bucket     = false
  bucket_name            = format("landingzone-log-audit-%s", random_string.random.result)
  bucket_storage_class   = "ColdArchive"
  bucket_redundancy_type = "LRS"
  bucket_tags = {
    "landingzone" : "logarchive"
  }
  bucket_force_destroy         = true
  bucket_resource_group_id     = null
  use_existed_archive_ram_role = false
  archive_ram_role_name        = "audit-log-cold-archive-role"
  # Please configure the logstore you need to cold archiving
  logstore_exports = [
    {
      logstore_name    = "oss_log"
      export_name      = "cold_archive_oss_log"
      display_name     = "cold_archive_oss_log"
      bucket_directory = "oss_log"
      suffix           = ""
      buffer_interval  = 300
      buffer_size      = 256
      compress_type    = "snappy"
      time_zone        = "+0800"
      content_type     = "json"
      path_format      = "%Y/%m/%d/%H/%M"
    }
  ]
}
