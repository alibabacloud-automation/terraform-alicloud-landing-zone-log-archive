Terraform module to implements Multi-Account Log Archive.

# terraform-alicloud-landing-zone-log-archive

[English](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-log-archive/blob/main/README.md) | 简体中文

日志审计既是企业安全合规的基础，也是国内外法律法规的刚性要求。在多账号体系下，审计日志的统一采集与归档，既可以确保相关法律法规的落地，也是企业安全防护的重要一环。

本Module基于日志服务的日志审计功能，实现云上审计日志自动化的统一采集和归档，满足在多账号体系下，企业在云上的相关审计和安全需求。

![Structure](https://raw.githubusercontent.com/alibabacloud-automation/terraform-alicloud-landing-zone-log-archive/main/pictures/structure-CN.png)

## 前提条件

- 基于资源目录构建多账号体系。
- 在日志账号中开通OSS和SLS。

## 使用方式

<div style="display: block;margin-bottom: 40px;"><div class="oics-button" style="float: right;position: absolute;margin-bottom: 10px;">
  <a href="https://api.aliyun.com/terraform?source=Module&activeTab=document&sourcePath=alibabacloud-automation%3A%3Alanding-zone-log-archive&spm=docs.m.alibabacloud-automation.landing-zone-log-archive&intl_lang=EN_US" target="_blank">
    <img alt="Open in AliCloud" src="https://img.alicdn.com/imgextra/i1/O1CN01hjjqXv1uYUlY56FyX_!!6000000006049-55-tps-254-36.svg" style="max-height: 44px; max-width: 100%;">
  </a>
</div></div>

您可以通过以下步骤在您的 terraform 模板中使用它。

```hcl
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
  source = "alibabacloud-automation/landing-zone-log-archive/alicloud"

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
  source = "alibabacloud-automation/landing-zone-log-archive/alicloud//modules/cold-archive-to-oss"
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
```

## SubModules

- [cold-archive-to-oss module](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-log-archive/tree/main/modules/cold-archive-to-oss)

## 示例

- [Basic Example](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-log-archive/tree/main/examples/basic)
- [Complete Example](https://github.com/alibabacloud-automation/terraform-alicloud-landing-zone-log-archive/tree/main/examples/complete)

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.229.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud.log_archive_account"></a> [alicloud.log\_archive\_account](#provider\_alicloud.log\_archive\_account) | >= 1.229.0 |
| <a name="provider_alicloud.management_account"></a> [alicloud.management\_account](#provider\_alicloud.management\_account) | >= 1.229.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_log_audit.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/log_audit) | resource |
| [alicloud_resource_manager_control_policy.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_control_policy) | resource |
| [alicloud_resource_manager_control_policy_attachment.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_control_policy_attachment) | resource |
| [alicloud_resource_manager_delegated_administrator.management](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_delegated_administrator) | resource |
| [alicloud_resource_manager_service_linked_role.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/resource_manager_service_linked_role) | resource |
| [alicloud_account.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/account) | data source |
| [alicloud_ram_roles.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/ram_roles) | data source |
| [alicloud_regions.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/regions) | data source |
| [alicloud_resource_manager_delegated_administrators.management](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/resource_manager_delegated_administrators) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_control_policy_description"></a> [control\_policy\_description](#input\_control\_policy\_description) | The description of the control policy. | `string` | `"Prohibit to delete resources for log archiving and auditing."` | no |
| <a name="input_control_policy_name"></a> [control\_policy\_name](#input\_control\_policy\_name) | The name of the control policy. | `string` | `"ProhibitDeleteLogAudit"` | no |
| <a name="input_enabled_control_policy"></a> [enabled\_control\_policy](#input\_enabled\_control\_policy) | Whether to enable control policy to prohibit deletion of resources for log archiving and auditing. | `bool` | `true` | no |
| <a name="input_log_audit_config"></a> [log\_audit\_config](#input\_log\_audit\_config) | Log audit detailed configuration. | <pre>object({<br/>    actiontrail_enabled             = optional(string, "false")<br/>    actiontrail_ttl                 = optional(string, "180")<br/>    oss_access_enabled              = optional(string, "false")<br/>    oss_access_ttl                  = optional(string, "7")<br/>    oss_sync_enabled                = optional(string, "true")<br/>    oss_sync_ttl                    = optional(string, "180")<br/>    oss_metering_enabled            = optional(string, "false")<br/>    oss_metering_ttl                = optional(string, "180")<br/>    rds_enabled                     = optional(string, "false")<br/>    rds_audit_collection_policy     = optional(string)<br/>    rds_ttl                         = optional(string, "180")<br/>    rds_slow_enabled                = optional(string, "false")<br/>    rds_slow_collection_policy      = optional(string)<br/>    rds_slow_ttl                    = optional(string, "180")<br/>    rds_perf_enabled                = optional(string, "false")<br/>    rds_perf_collection_policy      = optional(string)<br/>    rds_perf_ttl                    = optional(string, "180")<br/>    vpc_flow_enabled                = optional(string, "false")<br/>    vpc_flow_ttl                    = optional(string, "7")<br/>    vpc_flow_collection_policy      = optional(string)<br/>    vpc_sync_enabled                = optional(string, "true")<br/>    vpc_sync_ttl                    = optional(string, "180")<br/>    dns_intranet_enabled            = optional(string, "false")<br/>    dns_intranet_ttl                = optional(string, "7")<br/>    dns_intranet_collection_policy  = optional(string)<br/>    dns_sync_enabled                = optional(string, "true")<br/>    dns_sync_ttl                    = optional(string, "180")<br/>    polardb_enabled                 = optional(string, "false")<br/>    polardb_audit_collection_policy = optional(string)<br/>    polardb_ttl                     = optional(string, "180")<br/>    polardb_slow_enabled            = optional(string, "false")<br/>    polardb_slow_collection_policy  = optional(string)<br/>    polardb_slow_ttl                = optional(string, "180")<br/>    polardb_perf_enabled            = optional(string, "false")<br/>    polardb_perf_collection_policy  = optional(string)<br/>    polardb_perf_ttl                = optional(string, "180")<br/>    drds_audit_enabled              = optional(string, "false")<br/>    drds_audit_collection_policy     = optional(string)<br/>    drds_audit_ttl                  = optional(string, "7")<br/>    drds_sync_enabled               = optional(string, "true")<br/>    drds_sync_ttl                   = optional(string, "180")<br/>    slb_access_enabled              = optional(string, "false")<br/>    slb_access_collection_policy    = optional(string)<br/>    slb_access_ttl                  = optional(string, "7")<br/>    slb_sync_enabled                = optional(string, "true")<br/>    slb_sync_ttl                    = optional(string, "180")<br/>    bastion_enabled                 = optional(string, "false")<br/>    bastion_ttl                     = optional(string, "180")<br/>    waf_enabled                     = optional(string, "false")<br/>    waf_ttl                         = optional(string, "180")<br/>    cloudfirewall_enabled           = optional(string, "false")<br/>    cloudfirewall_ttl               = optional(string, "180")<br/>    cloudfirewall_vpc_enabled       = optional(string, "false")<br/>    cloudfirewall_vpc_ttl           = optional(string, "180")<br/>    ddos_coo_access_enabled         = optional(string, "false")<br/>    ddos_coo_access_ttl             = optional(string, "180")<br/>    ddos_bgp_access_enabled         = optional(string, "false")<br/>    ddos_bgp_access_ttl             = optional(string, "180")<br/>    ddos_dip_access_enabled         = optional(string, "false")<br/>    ddos_dip_access_ttl             = optional(string, "180")<br/>    sas_ttl                         = optional(string, "180")<br/>    sas_process_enabled             = optional(string, "false")<br/>    sas_network_enabled             = optional(string, "false")<br/>    sas_login_enabled               = optional(string, "false")<br/>    sas_crack_enabled               = optional(string, "false")<br/>    sas_snapshot_process_enabled    = optional(string, "false")<br/>    sas_snapshot_account_enabled    = optional(string, "false")<br/>    sas_snapshot_port_enabled       = optional(string, "false")<br/>    sas_dns_enabled                 = optional(string, "false")<br/>    sas_local_dns_enabled           = optional(string, "false")<br/>    sas_session_enabled             = optional(string, "false")<br/>    sas_http_enabled                = optional(string, "false")<br/>    sas_security_vul_enabled        = optional(string, "false")<br/>    sas_security_hc_enabled         = optional(string, "false")<br/>    sas_security_alert_enabled      = optional(string, "false")<br/>    apigateway_enabled              = optional(string, "false")<br/>    apigateway_ttl                  = optional(string, "180")<br/>    nas_enabled                     = optional(string, "false")<br/>    nas_ttl                         = optional(string, "180")<br/>    appconnect_enabled              = optional(string, "false")<br/>    appconnect_ttl                  = optional(string, "180")<br/>    cps_enabled                     = optional(string, "false")<br/>    cps_ttl                         = optional(string, "180")<br/>    k8s_audit_enabled               = optional(string, "false")<br/>    k8s_audit_collection_policy     = optional(string)<br/>    k8s_audit_ttl                   = optional(string, "180")<br/>    k8s_event_enabled               = optional(string, "false")<br/>    k8s_event_collection_policy     = optional(string)<br/>    k8s_event_ttl                   = optional(string, "180")<br/>    k8s_ingress_enabled             = optional(string, "false")<br/>    k8s_ingress_collection_policy   = optional(string)<br/>    k8s_ingress_ttl                 = optional(string, "180")<br/>    idaas_mng_enabled               = optional(string, "false")<br/>    idaas_mng_ttl                   = optional(string, "180")<br/>    idaas_mng_collection_policy     = optional(string)<br/>    idaas_user_enabled              = optional(string, "false")<br/>    idaas_user_ttl                  = optional(string, "180")<br/>  })</pre> | `null` | no |
| <a name="input_log_audit_display_name"></a> [log\_audit\_display\_name](#input\_log\_audit\_display\_name) | Name of SLS log audit. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_archive_project_name"></a> [log\_archive\_project\_name](#output\_log\_archive\_project\_name) | The namme of log archive project. |
| <a name="output_log_audit_id"></a> [log\_audit\_id](#output\_log\_audit\_id) | The ID of the log audit. |
| <a name="output_resource_manager_delegated_administrator_id"></a> [resource\_manager\_delegated\_administrator\_id](#output\_resource\_manager\_delegated\_administrator\_id) | The resource ID of Delegated Administrator. The value formats as <account\_id>:<service\_principal>. |
<!-- END_TF_DOCS -->

## 提交问题

如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/aliyun/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

## 作者

Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

## 许可

MIT Licensed. See LICENSE for full details.

## 参考

* [Terraform-Provider-Alicloud Github](https://github.com/aliyun/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://registry.terraform.io/providers/aliyun/alicloud/latest/docs)