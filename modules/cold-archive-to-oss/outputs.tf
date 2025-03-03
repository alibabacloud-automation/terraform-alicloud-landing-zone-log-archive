output "bucket_id" {
  value       = length(alicloud_oss_bucket.cold_archive) > 0 ? alicloud_oss_bucket.cold_archive[0].id : var.bucket_name
  description = " The id of the bucket. The value is the same as bucket name."
}

output "bucket_creation_date" {
  value       = one(alicloud_oss_bucket.cold_archive[*].creation_date)
  description = "The creation date of the bucket. If you use an existed OSS bucket, this value is null."
}

output "bucket_extranet_endpoint" {
  value       = one(alicloud_oss_bucket.cold_archive[*].extranet_endpoint)
  description = "The extranet access endpoint of the bucket. If you use an existed OSS bucket, this value is null."
}

output "bucket_intranet_endpoint" {
  value       = one(alicloud_oss_bucket.cold_archive[*].intranet_endpoint)
  description = "The intranet access endpoint of the bucket. If you use an existed OSS bucket, this value is null."
}

output "bucket_location" {
  value       = one(alicloud_oss_bucket.cold_archive[*].location)
  description = "The location of the bucket. If you use an existed OSS bucket, this value is null."
}

output "export_job_ids" {
  value = [
    for k, v in alicloud_log_oss_export.cold_archive : v.export_name
  ]
  description = "The list of export job ids."
}

output "export_jobs" {
  value = [
    for k, v in alicloud_log_oss_export.cold_archive : {
      id            = v.id
      job_id        = v.export_name
      project_name  = v.project_name
      logstore_name = v.logstore_name
      bucket_name   = v.bucket
    }
  ]
  description = "The list of export jobs."
}
