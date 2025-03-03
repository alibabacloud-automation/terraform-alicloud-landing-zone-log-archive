variable "project_name" {
  type        = string
  description = "The name of the sls project that should to be colde archived logs to OSS."
}

variable "use_existed_bucket" {
  type        = bool
  description = "Whether to use an existed OSS bucket."
  default     = false
}

variable "bucket_name" {
  type        = string
  description = "The name of the bucket. When use an existed OSS bucket, you should specify the existed bucket name."
}

variable "bucket_storage_class" {
  type        = string
  description = "The storage class to apply. Can be \"Standard\", \"IA\", \"Archive\", \"ColdArchive\" and \"DeepColdArchive\"."
  default     = "ColdArchive"
}

variable "bucket_redundancy_type" {
  type        = string
  description = "The redundancy type to enable. Can be \"LRS\", and \"ZRS\"."
  default     = "LRS"
}

variable "bucket_tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the oss bucket."
  default     = {}
}

variable "bucket_force_destroy" {
  type        = bool
  description = "A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default     = false
}

variable "bucket_resource_group_id" {
  type        = string
  description = "The ID of the resource group to which the bucket belongs."
  default     = null
}

variable "use_existed_archive_ram_role" {
  type        = bool
  default     = false
  description = "Whether to use an existed RAM role for archive."
}

variable "archive_ram_role_name" {
  type        = string
  description = "The name of ram role that sls will archive logs to oss by assuming this role."
}

variable "logstore_exports" {
  type = list(object({
    logstore_name    = string
    export_name      = string
    display_name     = optional(string)
    bucket_directory = optional(string)
    suffix           = optional(string)
    buffer_interval  = optional(number, 300)
    buffer_size      = optional(number, 256)
    compress_type    = optional(string, "snappy")
    time_zone        = optional(string, "+0800")
    content_type     = optional(string, "json")
    path_format      = optional(string, "%Y/%m/%d/%H/%M")
  }))
  description = "The logstores that cold archive to oss. You can config multiple and archive them to different oss bucket directories"
  default     = []
}
