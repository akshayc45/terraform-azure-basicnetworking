
resource "azurerm_storage_account" "boot_diagnostics" {
  count = var.boot_diagnostics && var.new_boot_diagnostics_storage_account != null ? 1 : 0

  account_replication_type         = var.new_boot_diagnostics_storage_account.account_replication_type
  account_tier                     = var.new_boot_diagnostics_storage_account.account_tier
  location                         = var.location
  name                             = coalesce(var.new_boot_diagnostics_storage_account.name, "bootdiag${lower(random_id.vm_sa.hex)}")
  resource_group_name              = var.resource_group_name
  access_tier                      = var.new_boot_diagnostics_storage_account.access_tier
  allow_nested_items_to_be_public  = var.new_boot_diagnostics_storage_account.allow_nested_items_to_be_public
  cross_tenant_replication_enabled = var.new_boot_diagnostics_storage_account.cross_tenant_replication_enabled
  default_to_oauth_authentication  = var.new_boot_diagnostics_storage_account.default_to_oauth_authentication
  enable_https_traffic_only        = var.new_boot_diagnostics_storage_account.enable_https_traffic_only
  min_tls_version                  = var.new_boot_diagnostics_storage_account.min_tls_version
  public_network_access_enabled    = var.new_boot_diagnostics_storage_account.public_network_access_enabled
  shared_access_key_enabled        = var.new_boot_diagnostics_storage_account.shared_access_key_enabled
  tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
    avm_git_commit           = "c01af1788f09558cf2ea3faea035bd95751da759"
    avm_git_file             = "main.tf"
    avm_git_last_modified_at = "2022-12-29 13:09:50"
    avm_git_org              = "Azure"
    avm_git_repo             = "terraform-azurerm-virtual-machine"
    avm_yor_trace            = "215680c8-4d1e-48e9-b963-f085642d4810"
  } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

  dynamic "blob_properties" {
    for_each = var.new_boot_diagnostics_storage_account.blob_properties == null ? [] : [
      "blob_properties"
    ]

    content {
      dynamic "container_delete_retention_policy" {
        for_each = var.new_boot_diagnostics_storage_account.blob_properties.container_delete_retention_policy == null ? [] : [
          "container_delete_retention_policy"
        ]

        content {
          days = var.new_boot_diagnostics_storage_account.blob_properties.container_delete_retention_policy.days
        }
      }
      dynamic "delete_retention_policy" {
        for_each = var.new_boot_diagnostics_storage_account.blob_properties.delete_retention_policy == null ? [] : [
          "delete_retention_policy"
        ]

        content {
          days = var.new_boot_diagnostics_storage_account.blob_properties.delete_retention_policy.days
        }
      }
      dynamic "restore_policy" {
        for_each = var.new_boot_diagnostics_storage_account.blob_properties.restore_policy == null ? [] : [
          "restore_policy"
        ]

        content {
          days = var.new_boot_diagnostics_storage_account.blob_properties.restore_policy.days
        }
      }
    }
  }
  #checkov:skip=CKV2_AZURE_1
  #checkov:skip=CKV2_AZURE_18
  dynamic "customer_managed_key" {
    for_each = var.new_boot_diagnostics_storage_account.customer_managed_key == null ? [] : [
      "customer_managed_key"
    ]

    content {
      key_vault_key_id          = var.new_boot_diagnostics_storage_account.customer_managed_key.key_vault_key_id
      user_assigned_identity_id = var.new_boot_diagnostics_storage_account.customer_managed_key.user_assigned_identity_id
    }
  }
  dynamic "identity" {
    for_each = var.new_boot_diagnostics_storage_account.identity == null ? [] : [
      "identity"
    ]

    content {
      type         = var.new_boot_diagnostics_storage_account.identity.type
      identity_ids = var.new_boot_diagnostics_storage_account.identity.identity_ids
    }
  }
}