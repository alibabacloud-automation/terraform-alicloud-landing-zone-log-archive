output "resource_manager_delegated_administrator_id" {
  value       = one(alicloud_resource_manager_delegated_administrator.management[*].id)
  description = "The resource ID of Delegated Administrator. The value formats as <account_id>:<service_principal>."
}

output "log_audit_id" {
  value       = alicloud_log_audit.log_archive.id
  description = "The ID of the log audit. "
}

output "log_archive_project_name" {
  value       = local.log_archive_project_name
  description = "The namme of log archive project."
}
