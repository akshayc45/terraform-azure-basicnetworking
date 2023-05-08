##########################
######## D D O S #########
##########################

# resource "azurerm_network_ddos_protection_plan" "azure-lz-ddos_prt"{
#    for_each = var.ddos_prt 
#    name =  each.value["name"]
#    location  =  each.value["location"]
#    resource_group_name = each.value["rgname"]
#    tags = merge({"ResourceName" = each.value["name"]},each.value["tags"],)
# }


###########################
#### LOG ANLY AUTO ACC ####
###########################

###AUTHOR :- Akshay Chavan
### 
resource "azurerm_automation_account" "azure-lz-automationacc" {
  name                = var.azurerm_automation_account_name
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  sku_name            = var.sku_name
  public_network_access_enabled = var.public_network_access_enabled

  tags = merge({ "ResourceName"            = "var.azurerm_automation_account_name"},var.tags_automation_acc)
}

resource "azurerm_log_analytics_workspace" "azure-lz-loganalyticsws" {
  name                = var.azurerm_log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.azurerm_resource_group
  sku                 = var.sku
  retention_in_days   = var.retention_in_days
  daily_quota_gb = var.daily_quota_gb
  internet_ingestion_enabled = var.internet_ingestion_enabled
  internet_query_enabled = var.internet_query_enabled 
  tags = merge({ "ResourceName"            = "var.var.azurerm_log_analytics_workspace_name"},var.tags_automation_acc)
}



resource "azurerm_log_analytics_linked_service" "azure-lz-linked-service" {
  resource_group_name = var.azurerm_resource_group
  workspace_id        = azurerm_log_analytics_workspace.hbl-lz-loganalyticsws.id
  read_access_id      = azurerm_automation_account.hbl-lz-automationacc.id
  depends_on = [azurerm_log_analytics_workspace.hbl-lz-loganalyticsws, azurerm_automation_account.hbl-lz-automationacc]

}
