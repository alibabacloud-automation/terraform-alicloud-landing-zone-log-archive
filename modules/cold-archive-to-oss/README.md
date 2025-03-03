This module will create an OSS Bucket and cold archive the logs in the logsotre to the OSS Bucket.

## Prerequisites

Enabled OSS service in logarchive account.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.229.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | >= 1.229.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_log_oss_export.cold_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/log_oss_export) | resource |
| [alicloud_oss_bucket.cold_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/oss_bucket) | resource |
| [alicloud_ram_policy.cold_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_policy) | resource |
| [alicloud_ram_role.cold_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_role) | resource |
| [alicloud_ram_role_policy_attachment.cold_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/ram_role_policy_attachment) | resource |
| [alicloud_account.log_archive](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/account) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_archive_ram_role_name"></a> [archive\_ram\_role\_name](#input\_archive\_ram\_role\_name) | The name of ram role that sls will archive logs to oss by assuming this role. | `string` | n/a | yes |
| <a name="input_bucket_force_destroy"></a> [bucket\_force\_destroy](#input\_bucket\_force\_destroy) | A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | The name of the bucket. When use an existed OSS bucket, you should specify the existed bucket name. | `string` | n/a | yes |
| <a name="input_bucket_redundancy_type"></a> [bucket\_redundancy\_type](#input\_bucket\_redundancy\_type) | The redundancy type to enable. Can be "LRS", and "ZRS". | `string` | `"LRS"` | no |
| <a name="input_bucket_resource_group_id"></a> [bucket\_resource\_group\_id](#input\_bucket\_resource\_group\_id) | The ID of the resource group to which the bucket belongs. | `string` | `null` | no |
| <a name="input_bucket_storage_class"></a> [bucket\_storage\_class](#input\_bucket\_storage\_class) | The storage class to apply. Can be "Standard", "IA", "Archive", "ColdArchive" and "DeepColdArchive". | `string` | `"ColdArchive"` | no |
| <a name="input_bucket_tags"></a> [bucket\_tags](#input\_bucket\_tags) | A mapping of tags to assign to the oss bucket. | `map(string)` | `{}` | no |
| <a name="input_logstore_exports"></a> [logstore\_exports](#input\_logstore\_exports) | The logstores that cold archive to oss. You can config multiple and archive them to different oss bucket directories | <pre>list(object({<br/>    logstore_name    = string<br/>    export_name      = string<br/>    display_name     = optional(string)<br/>    bucket_directory = optional(string)<br/>    suffix           = optional(string)<br/>    buffer_interval  = optional(number, 300)<br/>    buffer_size      = optional(number, 256)<br/>    compress_type    = optional(string, "snappy")<br/>    time_zone        = optional(string, "+0800")<br/>    content_type     = optional(string, "json")<br/>    path_format      = optional(string, "%Y/%m/%d/%H/%M")<br/>  }))</pre> | `[]` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The name of the sls project that should to be colde archived logs to OSS. | `string` | n/a | yes |
| <a name="input_use_existed_archive_ram_role"></a> [use\_existed\_archive\_ram\_role](#input\_use\_existed\_archive\_ram\_role) | Whether to use an existed RAM role for archive. | `bool` | `false` | no |
| <a name="input_use_existed_bucket"></a> [use\_existed\_bucket](#input\_use\_existed\_bucket) | Whether to use an existed OSS bucket. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_creation_date"></a> [bucket\_creation\_date](#output\_bucket\_creation\_date) | The creation date of the bucket. If you use an existed OSS bucket, this value is null. |
| <a name="output_bucket_extranet_endpoint"></a> [bucket\_extranet\_endpoint](#output\_bucket\_extranet\_endpoint) | The extranet access endpoint of the bucket. If you use an existed OSS bucket, this value is null. |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The id of the bucket. The value is the same as bucket name. |
| <a name="output_bucket_intranet_endpoint"></a> [bucket\_intranet\_endpoint](#output\_bucket\_intranet\_endpoint) | The intranet access endpoint of the bucket. If you use an existed OSS bucket, this value is null. |
| <a name="output_bucket_location"></a> [bucket\_location](#output\_bucket\_location) | The location of the bucket. If you use an existed OSS bucket, this value is null. |
| <a name="output_export_job_ids"></a> [export\_job\_ids](#output\_export\_job\_ids) | The list of export job ids. |
| <a name="output_export_jobs"></a> [export\_jobs](#output\_export\_jobs) | The list of export jobs. |
<!-- END_TF_DOCS -->