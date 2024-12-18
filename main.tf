variable "Request_Title" {
  type = string
  default = "KCMP Testing"
}
variable "Datacenter_Name" {
  type = string
  default = "Azure-East-Nonprod"
}
variable "Company" {
  type = string
  default = "Elevance Health"
}
variable "Server_Mnemonic" {
  type = string
  default = "other"
}
variable "Server_Mnemonic_Override" {
  type = string
  default = "MKS"
}
variable "Server_Role" {
  type = string
  default = "Application/Utility"
}
variable "Pattern_Name" {
  type    = string
  default = "Windows2019"
}
variable "Environment" {
  type    = string
  default = "Prod"
}
variable "Provisioning_Environment" {
  type    = string
  default = "stage"
}
variable "Cluster_Name" {
  type    = string
  default = "Default"
}
variable "Domain" {
  type    = string
  default = "wellpoint.com"
}
variable "Number_of_Virtual_CPUs" {
  type    = string
  default = "8"
}
variable "Memory" {
  type    = number
  default = 16
}
variable "Network_Zone" {
  type    = string
  default = "AppSeg"
}
variable "Network_Subzone" {
  type    = string
  default = "Anthem"
}
variable "Network_Segment" {
  type    = string
  default = "FrontEnd"
}
variable "Network_Subsegment" {
  type    = string
  default = "General"
}
variable "Patch_Week" {
  type    = string
  default = "Week 2"
}
variable "Patch_Day" {
  type    = string
  default = "Friday"
}
variable "Patch_Window" {
  type    = string
  default = "20:01:00 - 00:00:00"
}
variable "Patching_Contacts" {
  type    = string
  default = "AL49612"
}
variable "Patching_Email" {
  type    = string
  default = "Mukesh.Singh2@kyndryl.com"
}
variable "Server_Refresh" {
  type    = string
  default = "No"
}
variable "Requester_Name" {
  type    = string
  default = "Mukesh Singh"
}

locals {
  input_parameters = {
        cp4mcm_connection        = var.Datacenter_Name
        request_title            = var.Request_Title
        u_originating_company    = var.Company
        platform_family_name     = var.Server_Mnemonic
        platform_family_override = var.Server_Mnemonic_Override
        u_server_role            = var.Server_Role
        platform_code            = var.Pattern_Name == "RHEL 8" || var.Pattern_Name == "RHEL 9" ? "L" : "W"
        pattern_name             = var.Pattern_Name
        u_environment            = var.Environment == "Toss" ? "T" : "P"
        cluster_name             = var.Cluster_Name
        u_fqdn                   = var.Domain
        u_number_cpus            = var.Number_of_Virtual_CPUs
        u_ram                    = var.Memory
        network_zone             = var.Network_Zone
        network_subzone          = var.Network_Subzone
        network_segment          = var.Network_Segment
        network_subsegment       = var.Network_Subsegment
        patch_week               = var.Patch_Week
        u_patch_day              = var.Patch_Day
        u_patch_window           = var.Patch_Window
        u_patching_contacts      = var.Patching_Contacts
        u_patching_email         = var.Patching_Email
        server_refresh           = var.Server_Refresh
        provisioning_environment = var.Provisioning_Environment
        change_request           = "CHG0307717"
        svc_instnace             = "KCMP_POC_Testing"
        svc_name                 = "Simple_Linux_Pattern_Testing"
        svc_version              = "1.0.0"
  }
}

locals {
  common_config = {
    scriptinghost         = "10.152.0.195"
    scriptinghostuser     = "root"
    scriptinghostpassword = "ICL4wdc04"
    api_server            = "30.129.132.105"
    domain_svcid          = "srcISDM_Domain"
    domain_svcpasswd      = "2x49bWcYYNx!v!"
    svcid                 = "srcISDM_Domain"
    svcpasswd             = "2x49bWcYYNx!v!"
    infoblox_ip           = "30.132.128.188"
    infoblox_user         = "srcICODNS"
    infoblox_password     = "R3gistrDNS1-FunPLEAZ"
    tower                 = "wlp-build-decom-production.3scale.na1.cacf.kyndryl.net"
    servicenow_host       = "elevancehealthtest.service-now.com"
    servicenow_user       = "srcIBMMCMPAPI"
    servicenow_password   = ""
    vcenter_ip            = "10.65.153.196"
    vcenter_user          = "SVCISDMID@US"
    vcenter_password      = "M|n|()ns-D3sp|c4bl3-M3"
  }
}

###########################################################
#                Validate Paylaod Section                 #
###########################################################
## Validate payload resource
resource "camc_scriptpackage" "Validate_Payload" {
  program =["/opt/anthem/bin/validate_payload.py", "-j ${jsonencode(local.input_parameters)}"]
  on_create = true
}

## Below variable would be used to supply various values related to VM and Order to multiple templates in pattern. Map type output is mandatory to fetch required values from it.
output "input_parameters" {
  value = tomap(local.input_parameters)
}
