data "alicloud_account" "log_archive" {
  provider = alicloud.log_archive_account
}

locals {
  log_archive_account_id = data.alicloud_account.log_archive.id
}

# Delegate sls log audit administrator to log archive account
data "alicloud_resource_manager_delegated_administrators" "management" {
  provider          = alicloud.management_account
  service_principal = "audit.log.aliyuncs.com"
}

locals {
  delegated_administrator_account_ids = [
    for administrator in data.alicloud_resource_manager_delegated_administrators.management.administrators :
    administrator.account_id
  ]
}

resource "alicloud_resource_manager_delegated_administrator" "management" {
  provider = alicloud.management_account

  count             = contains(local.delegated_administrator_account_ids, local.log_archive_account_id) ? 0 : 1
  account_id        = local.log_archive_account_id
  service_principal = "audit.log.aliyuncs.com"
}

# Create sls log audit service linked role
data "alicloud_ram_roles" "log_archive" {
  provider   = alicloud.log_archive_account
  name_regex = "^(?i)AliyunServiceRoleForSLSAudit$"
}

resource "alicloud_resource_manager_service_linked_role" "log_archive" {
  provider = alicloud.log_archive_account

  count        = length(data.alicloud_ram_roles.log_archive.ids) > 0 ? 0 : 1
  service_name = "audit.log.aliyuncs.com"
}

# create sls log audit application
resource "alicloud_log_audit" "log_archive" {
  provider = alicloud.log_archive_account

  aliuid                  = local.log_archive_account_id
  display_name            = var.log_audit_display_name
  resource_directory_type = "all"

  variable_map = var.log_audit_config

  depends_on = [
    alicloud_resource_manager_delegated_administrator.management,
    alicloud_resource_manager_service_linked_role.log_archive
  ]
}

data "alicloud_regions" "log_archive" {
  provider = alicloud.log_archive_account

  current = true
}

locals {
  region_id                = one(data.alicloud_regions.log_archive.regions[*].id)
  log_archive_project_name = format("slsaudit-center-%s-%s", local.log_archive_account_id, local.region_id)
}

resource "alicloud_resource_manager_control_policy" "log_archive" {
  provider            = alicloud.management_account
  count               = var.enabled_control_policy ? 1 : 0
  control_policy_name = var.control_policy_name
  description         = var.control_policy_description
  effect_scope        = "RAM"
  policy_document     = <<EOF
  {
    "Version": "1",
    "Statement": [
      {
        "Effect": "Deny",
        "Action": [
          "log:DeleteProject",
          "log:DeleteLogStore"
        ],
        "Resource": [
          "acs:log:*:${local.log_archive_account_id}:project/${local.log_archive_project_name}",
          "acs:log:*:${local.log_archive_account_id}:project/${local.log_archive_project_name}/*",
          "acs:log:*:${local.log_archive_account_id}:project/${local.log_archive_project_name}/logstore/*"
        ]
      }
    ]
  }
  EOF
}

resource "alicloud_resource_manager_control_policy_attachment" "log_archive" {
  provider  = alicloud.management_account
  count     = var.enabled_control_policy ? 1 : 0
  policy_id = alicloud_resource_manager_control_policy.log_archive[0].id
  target_id = local.log_archive_account_id
}
