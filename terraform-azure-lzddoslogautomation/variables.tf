####################
####### DDOS #######
####################
# variable "ddos_prt"{
#   type = map(object({
#    name = string
#    location = string
#    rgname = string
#    tags = map(string)
#  }
# ))
# default = {}
# }


####################
######## LA ########
####################
#variable "subscription_id" {
##  description = "subscription id where resource should created"
#}
variable "azurerm_resource_group" {
  type = string
  description = "Resource Group Name"
}

variable "azurerm_automation_account_name" {
    type = string
    description = "Automation Account Name"
}

variable "location1" {
  type = string
  description = "Location"
}

variable "public_network_access_enabled" {
}
variable "azurerm_log_analytics_workspace_name" {
    type = string
    description = "Log Analytics Workspace Name"
}

variable "automation_account_tag" {
    type = map(string)
  default = {

  }
}

variable "sku_name" {
    description = "Sku Name"
}
variable "retention_in_days" {
    description = "The workspace data retention in days."
}

variable "sku" {
  type = string
  description = "SKU of the Log Analytics Workspace.ossible values are [ Free, PerNode, Premium, Standard, Standalone, Unlimited, CapacityReservation, and PerGB2018 ]"
}
variable "daily_quota_gb" {
    type = string  
    description = "The workspace daily quota for ingestion in GB. -1 for unlimited"
}

variable "internet_ingestion_enabled" {
}

variable "internet_query_enabled" {

}

variable "reservation_capacity_in_gb_per_day" {
    description = "The capacity reservation level in GB for this workspace. Only enable when sku is set to CapacityReservation"  
}

variable "tags_log_analytics" {
  description = "Tags associate log analytics workspace"
  type = map(string)
  default = {}

}

variable "tags_automation_acc" {
  description = "Tags associate with automation account"
  type = any
  default = {}
}
