variable "log_audit_display_name" {
  type        = string
  description = "Name of SLS log audit."
}

variable "log_audit_config" {
  type = object({
    actiontrail_enabled             = optional(string, "false")
    actiontrail_ttl                 = optional(string, "180")
    oss_access_enabled              = optional(string, "false")
    oss_access_ttl                  = optional(string, "7")
    oss_sync_enabled                = optional(string, "true")
    oss_sync_ttl                    = optional(string, "180")
    oss_metering_enabled            = optional(string, "false")
    oss_metering_ttl                = optional(string, "180")
    rds_enabled                     = optional(string, "false")
    rds_audit_collection_policy     = optional(string)
    rds_ttl                         = optional(string, "180")
    rds_slow_enabled                = optional(string, "false")
    rds_slow_collection_policy      = optional(string)
    rds_slow_ttl                    = optional(string, "180")
    rds_perf_enabled                = optional(string, "false")
    rds_perf_collection_policy      = optional(string)
    rds_perf_ttl                    = optional(string, "180")
    vpc_flow_enabled                = optional(string, "false")
    vpc_flow_ttl                    = optional(string, "7")
    vpc_flow_collection_policy      = optional(string)
    vpc_sync_enabled                = optional(string, "true")
    vpc_sync_ttl                    = optional(string, "180")
    dns_intranet_enabled            = optional(string, "false")
    dns_intranet_ttl                = optional(string, "7")
    dns_intranet_collection_policy  = optional(string)
    dns_sync_enabled                = optional(string, "true")
    dns_sync_ttl                    = optional(string, "180")
    polardb_enabled                 = optional(string, "false")
    polardb_audit_collection_policy = optional(string)
    polardb_ttl                     = optional(string, "180")
    polardb_slow_enabled            = optional(string, "false")
    polardb_slow_collection_policy  = optional(string)
    polardb_slow_ttl                = optional(string, "180")
    polardb_perf_enabled            = optional(string, "false")
    polardb_perf_collection_policy  = optional(string)
    polardb_perf_ttl                = optional(string, "180")
    drds_audit_enabled              = optional(string, "false")
    drds_audit_collection_policy    = optional(string)
    drds_audit_ttl                  = optional(string, "7")
    drds_sync_enabled               = optional(string, "true")
    drds_sync_ttl                   = optional(string, "180")
    slb_access_enabled              = optional(string, "false")
    slb_access_collection_policy    = optional(string)
    slb_access_ttl                  = optional(string, "7")
    slb_sync_enabled                = optional(string, "true")
    slb_sync_ttl                    = optional(string, "180")
    bastion_enabled                 = optional(string, "false")
    bastion_ttl                     = optional(string, "180")
    waf_enabled                     = optional(string, "false")
    waf_ttl                         = optional(string, "180")
    cloudfirewall_enabled           = optional(string, "false")
    cloudfirewall_ttl               = optional(string, "180")
    cloudfirewall_vpc_enabled       = optional(string, "false")
    cloudfirewall_vpc_ttl           = optional(string, "180")
    ddos_coo_access_enabled         = optional(string, "false")
    ddos_coo_access_ttl             = optional(string, "180")
    ddos_bgp_access_enabled         = optional(string, "false")
    ddos_bgp_access_ttl             = optional(string, "180")
    ddos_dip_access_enabled         = optional(string, "false")
    ddos_dip_access_ttl             = optional(string, "180")
    sas_ttl                         = optional(string, "180")
    sas_process_enabled             = optional(string, "false")
    sas_network_enabled             = optional(string, "false")
    sas_login_enabled               = optional(string, "false")
    sas_crack_enabled               = optional(string, "false")
    sas_snapshot_process_enabled    = optional(string, "false")
    sas_snapshot_account_enabled    = optional(string, "false")
    sas_snapshot_port_enabled       = optional(string, "false")
    sas_dns_enabled                 = optional(string, "false")
    sas_local_dns_enabled           = optional(string, "false")
    sas_session_enabled             = optional(string, "false")
    sas_http_enabled                = optional(string, "false")
    sas_security_vul_enabled        = optional(string, "false")
    sas_security_hc_enabled         = optional(string, "false")
    sas_security_alert_enabled      = optional(string, "false")
    apigateway_enabled              = optional(string, "false")
    apigateway_ttl                  = optional(string, "180")
    nas_enabled                     = optional(string, "false")
    nas_ttl                         = optional(string, "180")
    appconnect_enabled              = optional(string, "false")
    appconnect_ttl                  = optional(string, "180")
    cps_enabled                     = optional(string, "false")
    cps_ttl                         = optional(string, "180")
    k8s_audit_enabled               = optional(string, "false")
    k8s_audit_collection_policy     = optional(string)
    k8s_audit_ttl                   = optional(string, "180")
    k8s_event_enabled               = optional(string, "false")
    k8s_event_collection_policy     = optional(string)
    k8s_event_ttl                   = optional(string, "180")
    k8s_ingress_enabled             = optional(string, "false")
    k8s_ingress_collection_policy   = optional(string)
    k8s_ingress_ttl                 = optional(string, "180")
    idaas_mng_enabled               = optional(string, "false")
    idaas_mng_ttl                   = optional(string, "180")
    idaas_mng_collection_policy     = optional(string)
    idaas_user_enabled              = optional(string, "false")
    idaas_user_ttl                  = optional(string, "180")
  })
  description = "Log audit detailed configuration."
  default     = null
}

variable "enabled_control_policy" {
  type        = bool
  description = "Whether to enable control policy to prohibit deletion of resources for log archiving and auditing."
  default     = true
}

variable "control_policy_name" {
  type        = string
  description = "The name of the control policy."
  default     = "ProhibitDeleteLogAudit"
}

variable "control_policy_description" {
  type        = string
  description = "The description of the control policy."
  default     = "Prohibit to delete resources for log archiving and auditing."
}
