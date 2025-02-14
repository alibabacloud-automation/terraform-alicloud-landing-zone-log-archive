# Create a oss bucket
resource "alicloud_oss_bucket" "cold_archive" {
  count             = var.use_existed_bucket ? 0 : 1
  bucket            = var.bucket_name
  storage_class     = var.bucket_storage_class
  redundancy_type   = var.bucket_redundancy_type
  tags              = var.bucket_tags
  force_destroy     = var.bucket_force_destroy
  resource_group_id = var.bucket_resource_group_id

  lifecycle {
    ignore_changes = [
      cors_rule,
      website,
      logging,
      referer_config,
      lifecycle_rule,
      server_side_encryption_rule,
      versioning,
      transfer_acceleration,
      access_monitor
    ]
  }
}

locals {
  alicloud_ram_policy_name = format("%s-policy", var.archive_ram_role_name)
}

# Create ram role to export logs in logstore to oss
resource "alicloud_ram_policy" "cold_archive" {
  policy_name     = local.alicloud_ram_policy_name
  policy_document = <<EOF
  {
    "Version": "1",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "log:GetCursorOrData",
                "log:ListShards"
            ],
            "Resource": [
                "acs:log:*:*:project/${var.project_name}/logstore/*",
                "acs:log:*:*:project/${var.project_name}/logstore/*/*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": "oss:PutObject",
            "Resource": [
                "acs:oss:*:*:${var.bucket_name}",
                "acs:oss:*:*:${var.bucket_name}/*"
            ]
        }
    ]
  }
  EOF
}

module "cold_archive_ram_role" {
  source = "terraform-alicloud-modules/ram-role/alicloud"
  count  = var.use_existed_archive_ram_role ? 0 : 1

  role_name = var.archive_ram_role_name
  services  = ["log.aliyuncs.com"]
  policies = [
    {
      policy_names = local.alicloud_ram_policy_name
    }
  ]

  depends_on = [
    alicloud_ram_policy.cold_archive
  ]
}

data "alicloud_account" "log_archive" {
}

# Create logstore exports
resource "alicloud_log_oss_export" "cold_archive" {
  for_each = {
    for export in var.logstore_exports : export.logstore_name => export
  }

  project_name      = var.project_name
  logstore_name     = each.key
  export_name       = each.value.export_name
  display_name      = each.value.display_name
  prefix            = each.value.bucket_directory
  suffix            = each.value.suffix
  bucket            = var.bucket_name
  buffer_interval   = each.value.buffer_interval
  buffer_size       = each.value.buffer_size
  role_arn          = format("acs:ram::%s:role/%s", data.alicloud_account.log_archive.id, var.archive_ram_role_name)
  log_read_role_arn = format("acs:ram::%s:role/%s", data.alicloud_account.log_archive.id, var.archive_ram_role_name)
  compress_type     = each.value.compress_type
  path_format       = each.value.path_format
  time_zone         = each.value.time_zone
  content_type      = each.value.content_type

  depends_on = [
    alicloud_oss_bucket.cold_archive,
    module.cold_archive_ram_role
  ]
}
