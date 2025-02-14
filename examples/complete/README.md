# Complete

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan -var='log_archive_account_id=${your_log_archive_account_id}'
$ terraform apply -var='log_archive_account_id=${your_log_archive_account_id}'
```

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.229.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.3 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.3 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cold_archive_to_oss"></a> [cold\_archive\_to\_oss](#module\_cold\_archive\_to\_oss) | ../../modules/cold-archive-to-oss | n/a |
| <a name="module_log_archive"></a> [log\_archive](#module\_log\_archive) | ../../ | n/a |

## Resources

| Name | Type |
|------|------|
| [random_string.random](https://registry.terraform.io/providers/hashicorp/random/3.6.3/docs/resources/string) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_archive_account_id"></a> [log\_archive\_account\_id](#input\_log\_archive\_account\_id) | The account ID of the log archive account. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cold_archive_to_oss"></a> [cold\_archive\_to\_oss](#output\_cold\_archive\_to\_oss) | The outputs of cold archive to OSS. |
| <a name="output_log_archive_project_name"></a> [log\_archive\_project\_name](#output\_log\_archive\_project\_name) | The namme of log archive project. |
| <a name="output_log_audit_id"></a> [log\_audit\_id](#output\_log\_audit\_id) | The ID of the log audit. |
| <a name="output_resource_manager_delegated_administrator_id"></a> [resource\_manager\_delegated\_administrator\_id](#output\_resource\_manager\_delegated\_administrator\_id) | The resource ID of Delegated Administrator. The value formats as <account\_id>:<service\_principal>. |
<!-- END_TF_DOCS -->