resource "tls_private_key" "rsa" {
  count     = var.disable_password_authentication ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 4096
}

#############################################
##############  L I N U X V M  ##############
#############################################

resource "azurerm_linux_virtual_machine" "vm_linux" {
  count = lower(var.os_type) == "linux" ? 1 : 0
  #for_each = lower(var.os_type) == "linux" ? var.linux_vm : {}

  admin_username                  = var.admin_username
  location                        = var.location
  name                            = var.name
  network_interface_ids           = var.network_interface_ids
  resource_group_name             = var.resource_group_name
  size                            = var.size
  admin_password                  = var.admin_password
  allow_extension_operations      = var.allow_extension_operations
  availability_set_id             = var.availability_set_id
  capacity_reservation_group_id   = var.capacity_reservation_group_id
  computer_name                   = var.computer_name
  custom_data                     = var.custom_data
  dedicated_host_group_id         = var.dedicated_host_group_id
  dedicated_host_id               = var.dedicated_host_id
  disable_password_authentication = var.disable_password_authentication
  edge_zone                       = var.edge_zone
  encryption_at_host_enabled      = var.encryption_at_host_enabled
  eviction_policy                 = var.eviction_policy
  extensions_time_budget          = var.extensions_time_budget
  license_type                    = var.license_type
  max_bid_price                   = var.max_bid_price
  patch_assessment_mode           = var.patch_assessment_mode
  patch_mode                      = var.patch_mode
  platform_fault_domain           = var.platform_fault_domain
  priority                        = var.priority
  provision_vm_agent              = var.provision_vm_agent
  proximity_placement_group_id    = var.proximity_placement_group_id
  secure_boot_enabled             = var.secure_boot_enabled
  source_image_id                 = var.source_image_id
  user_data                       = var.user_data
  virtual_machine_scale_set_id    = var.virtual_machine_scale_set_id
  vtpm_enabled                    = var.vtpm_enabled
  zone                            = var.zone
  tags                            = var.tags

  os_disk {
    caching                          = var.os_disk.caching
    storage_account_type             = var.os_disk.storage_account_type
    disk_encryption_set_id           = var.os_disk.disk_encryption_set_id
    disk_size_gb                     = var.os_disk.disk_size_gb
    name                             = var.os_disk.name
    secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
    security_encryption_type         = var.os_disk.security_encryption_type
    write_accelerator_enabled        = var.os_disk.write_accelerator_enabled

    dynamic "diff_disk_settings" {
      for_each = var.os_disk.diff_disk_settings == null ? [] : [
        "diff_disk_settings"
      ]

      content {
        option    = var.os_disk.diff_disk_settings.option
        placement = var.os_disk.diff_disk_settings.placement
      }
    }
  }
  dynamic "additional_capabilities" {
    for_each = var.vm_additional_capabilities == null ? [] : [
      "additional_capabilities"
    ]

    content {
      ultra_ssd_enabled = var.vm_additional_capabilities.ultra_ssd_enabled
    }
  }
  dynamic "admin_ssh_key" {
    for_each = var.disable_password_authentication ? [1] : []
    content {
      username   = try(var.admin_username, "azureuser")
      public_key = var.admin_ssh_key_data == null ? tls_private_key.rsa[0].public_key_openssh : var.admin_ssh_key_data
    }
  }

  dynamic "boot_diagnostics" {
    for_each = var.enable_boot_diagnostics ? [1] : []
    content {
      storage_account_uri = var.storage_account_name != null ? data.azurerm_storage_account.storeacc.0.primary_blob_endpoint : var.storage_account_uri
    }
  }

  dynamic "gallery_application" {
    for_each = toset(var.gallery_application)
    content {
      version_id             = var.gallery_application.version_id
      configuration_blob_uri = var.gallery_application.configuration_blob_uri
      order                  = var.gallery_application.order
      tag                    = var.gallery_application.tag
    }
  }

  dynamic "identity" {
    for_each = var.identity == null ? [] : ["identity"]

    content {
      type         = var.identity.type
      identity_ids = var.identity.identity_ids
    }
  }
  dynamic "plan" {
    for_each = var.plan == null ? [] : ["plan"]

    content {
      name      = var.plan.name
      product   = var.plan.product
      publisher = var.plan.publisher
    }
  }
  dynamic "secret" {
    for_each = toset(var.secrets)

    content {
      key_vault_id = secret.value.key_vault_id

      dynamic "certificate" {
        for_each = secret.value.certificate

        content {
          url = certificate.value.url
        }
      }
    }
  }
  dynamic "source_image_reference" {
    for_each = var.source_image_reference == null ? [] : ["source_image_reference"]
    content {
      offer     = var.source_image_reference.offer
      publisher = var.source_image_reference.publisher
      sku       = var.source_image_reference.sku
      version   = var.source_image_reference.version
    }
  }
  dynamic "termination_notification" {
    for_each = var.termination_notification == null ? [] : ["termination_notification"]
    content {
      enabled = var.termination_notification.enabled
      timeout = var.termination_notification.timeout
    }
  }
}


# #############################################
# ############  W I N D O W S V M  ############
# #############################################

# resource "azurerm_windows_virtual_machine" "vm_windows" {
#   count = lower(var.os_type) == "windows" ? 1 : 0

#   admin_password                = var.admin_password
#   admin_username                = var.admin_username
#   location                      = var.location
#   name                          = var.name
#   network_interface_ids         = var.network_interface_ids
#   resource_group_name           = var.resource_group_name
#   size                          = var.size
#   allow_extension_operations    = var.allow_extension_operations
#   availability_set_id           = var.availability_set_id
#   capacity_reservation_group_id = var.capacity_reservation_group_id
#   computer_name                 = var.computer_name
#   custom_data                   = var.custom_data
#   dedicated_host_group_id       = var.dedicated_host_group_id
#   dedicated_host_id             = var.dedicated_host_id
#   edge_zone                     = var.edge_zone
#   enable_automatic_updates      = var.automatic_updates_enabled
#   encryption_at_host_enabled    = var.encryption_at_host_enabled
#   eviction_policy               = var.eviction_policy
#   extensions_time_budget        = var.extensions_time_budget
#   hotpatching_enabled           = var.hotpatching_enabled
#   license_type                  = var.license_type
#   max_bid_price                 = var.max_bid_price
#   patch_assessment_mode         = var.patch_assessment_mode
#   patch_mode                    = var.patch_mode
#   platform_fault_domain         = var.platform_fault_domain
#   priority                      = var.priority
#   provision_vm_agent            = var.provision_vm_agent
#   proximity_placement_group_id  = var.proximity_placement_group_id
#   secure_boot_enabled           = var.secure_boot_enabled
#   source_image_id               = var.source_image_id
#   tags = var.tags
#   timezone                     = var.timezone
#   user_data                    = var.user_data
#   virtual_machine_scale_set_id = var.virtual_machine_scale_set_id
#   vtpm_enabled                 = var.vtpm_enabled
#   zone                         = var.zone

#   os_disk {
#     caching                          = var.os_disk.caching
#     storage_account_type             = var.os_disk.storage_account_type
#     disk_encryption_set_id           = var.os_disk.disk_encryption_set_id
#     disk_size_gb                     = var.os_disk.disk_size_gb
#     name                             = var.os_disk.name
#     secure_vm_disk_encryption_set_id = var.os_disk.secure_vm_disk_encryption_set_id
#     security_encryption_type         = var.os_disk.security_encryption_type
#     write_accelerator_enabled        = var.os_disk.write_accelerator_enabled

#     dynamic "diff_disk_settings" {
#       for_each = var.os_disk.diff_disk_settings == null ? [] : [
#         "diff_disk_settings"
#       ]

#       content {
#         option    = var.os_disk.diff_disk_settings.option
#         placement = var.os_disk.diff_disk_settings.placement
#       }
#     }
#   }
#   dynamic "additional_capabilities" {
#     for_each = var.vm_additional_capabilities == null ? [] : [
#       "additional_capabilities"
#     ]

#     content {
#       ultra_ssd_enabled = var.vm_additional_capabilities.ultra_ssd_enabled
#     }
#   }
#   dynamic "additional_unattend_content" {
#     for_each = {
#       for c in var.additional_unattend_contents : jsonencode(c) => c
#     }

#     content {
#       content = additional_unattend_content.value.content
#       setting = additional_unattend_content.value.setting
#     }
#   }
#   dynamic "boot_diagnostics" {
#     for_each = var.enable_boot_diagnostics ? [1] : []
#     content {
#       storage_account_uri = var.storage_account_name != null ? data.azurerm_storage_account.storeacc.0.primary_blob_endpoint : var.storage_account_uri
#     }
#   }
#   dynamic "gallery_application" {
#     for_each = toset(var.gallery_application)
#     content {
#       version_id             = var.gallery_application.version_id
#       configuration_blob_uri = var.gallery_application.configuration_blob_uri
#       order                  = var.gallery_application.order
#       tag                    = var.gallery_application.tag
#     }
#   }
#   dynamic "identity" {
#     for_each = var.identity == null ? [] : ["identity"]

#     content {
#       type         = var.identity.type
#       identity_ids = var.identity.identity_ids
#     }
  
#   dynamic "plan" {
#     for_each = var.plan == null ? [] : ["plan"]

#     content {
#       name      = var.plan.name
#       product   = var.plan.product
#       publisher = var.plan.publisher
#     }
#   }
#   dynamic "secret" {
#     for_each = toset(var.secrets)

#     content {
#       key_vault_id = secret.value.key_vault_id

#       dynamic "certificate" {
#         for_each = secret.value.certificate
#         content {
#           store = certificate.value.store
#           url   = certificate.value.url
#         }
#       }
#     }
#   }
#   dynamic "source_image_reference" {
#     for_each = var.source_image_reference == null ? [] : ["source_image_reference"]
#     content {
#       offer     = var.source_image_reference.offer
#       publisher = var.source_image_reference.publisher
#       sku       = var.source_image_reference.sku
#       version   = var.source_image_reference.version
#     }
#   }
#   dynamic "termination_notification" {
#     for_each = var.termination_notification == null ? [] : [ "termination_notification" ]
#     content {
#       enabled = var.termination_notification.enabled
#       timeout = var.termination_notification.timeout
#     }
#   }
#   dynamic "winrm_listener" {
#     for_each = var.winrm_listeners 
#     content {
#       protocol        = winrm_listener.value.protocol
#       certificate_url = winrm_listener.value.certificate_url
#     }
#   }
# }
# }

# resource "azurerm_network_interface" "vm" {
#   count = var.new_network_interface != null ? 1 : 0

#   location                      = var.location
#   name                          = coalesce(var.new_network_interface.name, "${var.name}-nic")
#   resource_group_name           = var.resource_group_name
#   dns_servers                   = var.new_network_interface.dns_servers
#   edge_zone                     = var.new_network_interface.edge_zone
#   enable_accelerated_networking = var.new_network_interface.accelerated_networking_enabled
#   #checkov:skip=CKV_AZURE_118
#   enable_ip_forwarding    = var.new_network_interface.ip_forwarding_enabled
#   internal_dns_name_label = var.new_network_interface.internal_dns_name_label
#   tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
#     avm_git_commit           = "c6c30c1119c3d25829b29efc3cc629b5d4767301"
#     avm_git_file             = "main.tf"
#     avm_git_last_modified_at = "2023-01-17 02:03:20"
#     avm_git_org              = "Azure"
#     avm_git_repo             = "terraform-azurerm-virtual-machine"
#     avm_yor_trace            = "cfa0bd9f-8637-4fb4-ac63-f449b56caf32"
#   } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

#   dynamic "ip_configuration" {
#     for_each = local.network_interface_ip_configuration_indexes

#     content {
#       name                                               = coalesce(var.new_network_interface.ip_configurations[ip_configuration.value].name, "${var.name}-nic${ip_configuration.value}")
#       private_ip_address_allocation                      = var.new_network_interface.ip_configurations[ip_configuration.value].private_ip_address_allocation
#       gateway_load_balancer_frontend_ip_configuration_id = var.new_network_interface.ip_configurations[ip_configuration.value].gateway_load_balancer_frontend_ip_configuration_id
#       primary                                            = var.new_network_interface.ip_configurations[ip_configuration.value].primary
#       private_ip_address                                 = var.new_network_interface.ip_configurations[ip_configuration.value].private_ip_address
#       private_ip_address_version                         = var.new_network_interface.ip_configurations[ip_configuration.value].private_ip_address_version
#       public_ip_address_id                               = var.new_network_interface.ip_configurations[ip_configuration.value].public_ip_address_id
#       subnet_id                                          = var.subnet_id
#     }
#   }

#   lifecycle {
#     precondition {
#       condition     = var.network_interface_ids == null
#       error_message = "`new_network_interface` cannot be used along with `network_interface_ids`."
#     }
#   }
# }

# locals {
#   network_interface_ids = var.new_network_interface != null ? [
#     azurerm_network_interface.vm[0].id
#   ] : var.network_interface_ids
# }

# resource "azurerm_managed_disk" "disk" {
#   for_each = { for d in var.data_disks : d.attach_setting.lun => d }

#   create_option                    = each.value.create_option
#   location                         = var.location
#   name                             = each.value.name
#   resource_group_name              = var.resource_group_name
#   storage_account_type             = each.value.storage_account_type
#   disk_access_id                   = each.value.disk_access_id
#   disk_encryption_set_id           = each.value.disk_encryption_set_id
#   disk_iops_read_only              = each.value.disk_iops_read_only
#   disk_iops_read_write             = each.value.disk_iops_read_write
#   disk_mbps_read_only              = each.value.disk_mbps_read_only
#   disk_mbps_read_write             = each.value.disk_mbps_read_write
#   disk_size_gb                     = each.value.disk_size_gb
#   edge_zone                        = var.edge_zone
#   gallery_image_reference_id       = each.value.gallery_image_reference_id
#   hyper_v_generation               = each.value.hyper_v_generation
#   image_reference_id               = each.value.image_reference_id
#   logical_sector_size              = each.value.logical_sector_size
#   max_shares                       = each.value.max_shares
#   network_access_policy            = each.value.network_access_policy
#   on_demand_bursting_enabled       = each.value.on_demand_bursting_enabled
#   os_type                          = title(var.image_os)
#   public_network_access_enabled    = each.value.public_network_access_enabled
#   secure_vm_disk_encryption_set_id = each.value.secure_vm_disk_encryption_set_id
#   security_type                    = each.value.security_type
#   source_resource_id               = each.value.source_resource_id
#   source_uri                       = each.value.source_uri
#   storage_account_id               = each.value.storage_account_id
#   tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
#     avm_git_commit           = "c6c30c1119c3d25829b29efc3cc629b5d4767301"
#     avm_git_file             = "main.tf"
#     avm_git_last_modified_at = "2023-01-17 02:03:20"
#     avm_git_org              = "Azure"
#     avm_git_repo             = "terraform-azurerm-virtual-machine"
#     avm_yor_trace            = "447af86b-2cb9-4571-a234-e7e548dab9d0"
#   } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))
#   tier                   = each.value.tier
#   trusted_launch_enabled = each.value.trusted_launch_enabled
#   upload_size_bytes      = each.value.upload_size_bytes
#   zone                   = var.zone

#   dynamic "encryption_settings" {
#     for_each = each.value.encryption_settings == null ? [] : [
#       "encryption_settings"
#     ]

#     content {
#       dynamic "disk_encryption_key" {
#         for_each = each.value.encryption_settings.disk_encryption_key == null ? [] : [
#           "disk_encryption_key"
#         ]

#         content {
#           secret_url      = each.value.encryption_settings.disk_encryption_key.secret_url
#           source_vault_id = each.value.encryption_settings.disk_encryption_key.source_vault_id
#         }
#       }
#       dynamic "key_encryption_key" {
#         for_each = each.value.encryption_settings.key_encryption_key == null ? [] : [
#           "key_encryption_key"
#         ]

#         content {
#           key_url         = each.value.encryption_settings.key_encryption_key.key_url
#           source_vault_id = each.value.encryption_settings.key_encryption_key.source_vault_id
#         }
#       }
#     }
#   }
# }

# resource "azurerm_virtual_machine_data_disk_attachment" "attachment" {
#   for_each = {
#     for d in var.data_disks : d.attach_setting.lun => d.attach_setting
#   }

#   caching                   = each.value.caching
#   lun                       = each.value.lun
#   managed_disk_id           = azurerm_managed_disk.disk[each.key].id
#   virtual_machine_id        = local.virtual_machine.id
#   create_option             = each.value.create_option
#   write_accelerator_enabled = each.value.write_accelerator_enabled
# }

# resource "azurerm_virtual_machine_extension" "extensions" {
#   # The `sensitive` inside `nonsensitive` is a workaround for https://github.com/terraform-linters/tflint-ruleset-azurerm/issues/229
#   for_each = nonsensitive({ for e in var.extensions : e.name => e })

#   name                        = each.key
#   publisher                   = each.value.publisher
#   type                        = each.value.type
#   type_handler_version        = each.value.type_handler_version
#   virtual_machine_id          = local.virtual_machine.id
#   auto_upgrade_minor_version  = each.value.auto_upgrade_minor_version
#   automatic_upgrade_enabled   = each.value.automatic_upgrade_enabled
#   failure_suppression_enabled = each.value.failure_suppression_enabled
#   protected_settings          = each.value.protected_settings
#   settings                    = each.value.settings
#   tags = merge(var.tags, (/*<box>*/ (var.tracing_tags_enabled ? { for k, v in /*</box>*/ {
#     avm_git_commit           = "c6c30c1119c3d25829b29efc3cc629b5d4767301"
#     avm_git_file             = "main.tf"
#     avm_git_last_modified_at = "2023-01-17 02:03:20"
#     avm_git_org              = "Azure"
#     avm_git_repo             = "terraform-azurerm-virtual-machine"
#     avm_yor_trace            = "74bdb3b4-9c66-4fb5-88d0-7856c8df382d"
#   } /*<box>*/ : replace(k, "avm_", var.tracing_tags_prefix) => v } : {}) /*</box>*/))

#   dynamic "protected_settings_from_key_vault" {
#     for_each = each.value.protected_settings_from_key_vault == null ? [] : [
#       "protected_settings_from_key_vault"
#     ]

#     content {
#       secret_url      = each.value.protected_settings_from_key_vault.secret_url
#       source_vault_id = each.value.protected_settings_from_key_vault.source_vault_id
#     }
#   }
# }
