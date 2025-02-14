output "resource_manager_delegated_administrator_id" {
  value       = module.log_archive.resource_manager_delegated_administrator_id
  description = "The resource ID of Delegated Administrator. The value formats as <account_id>:<service_principal>."
}

output "log_audit_id" {
  value       = module.log_archive.log_audit_id
  description = "The ID of the log audit. "
}

output "log_archive_project_name" {
  value       = module.log_archive.log_archive_project_name
  description = "The namme of log archive project."
}

output "cold_archive_to_oss" {
  value       = module.cold_archive_to_oss
  description = "The outputs of cold archive to OSS."
}
