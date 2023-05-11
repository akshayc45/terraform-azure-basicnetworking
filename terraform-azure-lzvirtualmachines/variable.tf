variable "os_type" {
  type = string
  nullable = false
  description = "Type of os vm need to deplo, Possible valuse are linux or windows."
}
variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "(Optional) The admin username of the VM that will be deployed."
  nullable    = false
}

variable "location" {
  type        = string
  description = "(Required) The Azure location where the Virtual Machine should exist. Changing this forces a new resource to be created."
  nullable    = false
}

variable "name" {
  type        = string
  description = "(Required) The name of the Virtual Machine. Changing this forces a new resource to be created."
  nullable    = false
}
variable "network_interface_ids" {
  type        = list(string)
  default     = null
  description = "A list of Network Interface IDs which should be attached to this Virtual Machine. The first Network Interface ID in this list will be the Primary Network Interface on the Virtual Machine. Cannot be used along with `new_network_interface`."
}

variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group in which the Virtual Machine should be exist. Changing this forces a new resource to be created."
  nullable    = false
}
variable "size" {
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine, such as `Standard_F2`."
  nullable    = false
}
variable "admin_password" {
  type        = string
  default     = null
  description = "(Optional) The Password which should be used for the local-administrator on this Virtual Machine Required when using Windows Virtual Machine. Changing this forces a new resource to be created. When an `admin_password` is specified `disable_password_authentication` must be set to `false`. One of either `admin_password` or `admin_ssh_key` must be specified."
  sensitive   = true
}
variable "allow_extension_operations" {
  type        = bool
  default     = false
  description = "(Optional) Should Extension Operations be allowed on this Virtual Machine? Defaults to `false`."
}
variable "availability_set_id" {
  type        = string
  default     = null
  description = "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist. Cannot be used along with `new_availability_set`, `new_capacity_reservation_group`, `capacity_reservation_group_id`, `virtual_machine_scale_set_id`, `zone`. Changing this forces a new resource to be created."
}

variable "capacity_reservation_group_id" {
  type        = string
  default     = null
  description = "(Optional) Specifies the ID of the Capacity Reservation Group which the Virtual Machine should be allocated to. Cannot be used with `new_capacity_reservation_group`, `availability_set_id`, `new_availability_set`, `proximity_placement_group_id`."
}
variable "computer_name" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Hostname which should be used for this Virtual Machine. If unspecified this defaults to the value for the `vm_name` field. If the value of the `vm_name` field is not a valid `computer_name`, then you must specify `computer_name`. Changing this forces a new resource to be created."
}
variable "custom_data" {
  type        = string
  default     = null
  description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
}
variable "dedicated_host_group_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of a Dedicated Host Group that this Linux Virtual Machine should be run within. Conflicts with `dedicated_host_id`."
}
variable "dedicated_host_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with `dedicated_host_group_id`."
}
variable "disable_password_authentication" {
  type = bool
  default = false
  nullable = false
}
variable "edge_zone" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Edge Zone within the Azure Region where this Linux Virtual Machine should exist. Changing this forces a new Virtual Machine to be created."
}

variable "encryption_at_host_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host?"
}

variable "eviction_policy" {
  type        = string
  default     = null
  description = "(Optional) Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance. Possible values are `Deallocate` and `Delete`. Changing this forces a new resource to be created."
}

variable "extensions_time_budget" {
  type        = string
  default     = "PT1H30M"
  description = "(Optional) Specifies the duration allocated for all extensions to start. The time duration should be between 15 minutes and 120 minutes (inclusive) and should be specified in ISO 8601 format. Defaults to 90 minutes (`PT1H30M`)."
}
variable "license_type" {
  type        = string
  default     = null
  description = "(Optional) For Linux virtual machine specifies the BYOL Type for this Virtual Machine, possible values are `RHEL_BYOS` and `SLES_BYOS`. For Windows virtual machine specifies the type of on-premise license (also known as [Azure Hybrid Use Benefit](https://docs.microsoft.com/windows-server/get-started/azure-hybrid-benefit)) which should be used for this Virtual Machine, possible values are `None`, `Windows_Client` and `Windows_Server`."
}
variable "max_bid_price" {
  type        = number
  default     = -1
  description = "(Optional) The maximum price you're willing to pay for this Virtual Machine, in US Dollars; which must be greater than the current spot price. If this bid price falls below the current spot price the Virtual Machine will be evicted using the `eviction_policy`. Defaults to `-1`, which means that the Virtual Machine should not be evicted for price reasons. This can only be configured when `priority` is set to `Spot`."
}


variable "patch_assessment_mode" {
  type        = string
  default     = "ImageDefault"
  description = "(Optional) Specifies the mode of VM Guest Patching for the Virtual Machine. Possible values are `AutomaticByPlatform` or `ImageDefault`. Defaults to `ImageDefault`."
}

variable "patch_mode" {
  type        = string
  default     = null
  description = "(Optional) Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are AutomaticByPlatform and ImageDefault. Defaults to ImageDefault"
}
 
variable "platform_fault_domain" {
  type = number
  # Why use `null` instead of [`-1`](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine#platform_fault_domain) as default value? `platform_fault_domain` must be set along with `virtual_machine_scale_set_id` so the default value must be `null` for this module if we don't want to use `virtual_machine_scale_set_id`.
  default     = null
  description = "(Optional) Specifies the Platform Fault Domain in which this Virtual Machine should be created. Defaults to `null`, which means this will be automatically assigned to a fault domain that best maintains balance across the available fault domains. `virtual_machine_scale_set_id` is required with it. Changing this forces new Virtual Machine to be created."
}

variable "priority" {
  type        = string
  default     = "Regular"
  description = "(Optional) Specifies the priority of this Virtual Machine. Possible values are `Regular` and `Spot`. Defaults to `Regular`. Changing this forces a new resource to be created."
}

variable "provision_vm_agent" {
  type        = bool
  default     = true
  description = "(Optional) Should the Azure VM Agent be provisioned on this Virtual Machine? Defaults to `true`. Changing this forces a new resource to be created. If `provision_vm_agent` is set to `false` then `allow_extension_operations` must also be set to `false`."
}

variable "proximity_placement_group_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Proximity Placement Group which the Virtual Machine should be assigned to. Conflicts with `capacity_reservation_group_id`."
}
variable "secure_boot_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created."
}

variable "source_image_id" {
  type        = string
  default     = null
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. Possible Image ID types include `Image ID`s, `Shared Image ID`s, `Shared Image Version ID`s, `Community Gallery Image ID`s, `Community Gallery Image Version ID`s, `Shared Gallery Image ID`s and `Shared Gallery Image Version ID`s. One of either `source_image_id` or `source_image_reference` must be set."
}
variable "user_data" {
  type        = string
  default     = null
  description = "(Optional) The Base64-Encoded User Data which should be used for this Virtual Machine."

  validation {
    condition     = var.user_data == null ? true : can(base64decode(var.user_data))
    error_message = "`user_data` must be either `null` or valid base64 encoded string."
  }
}

variable "virtual_machine_scale_set_id" {
  type        = string
  default     = null
  description = "(Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within. Conflicts with `availability_set_id`. Changing this forces a new resource to be created."
}
variable "vtpm_enabled" {
  type        = bool
  default     = null
  description = "(Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created."
}
variable "zone" {
  type        = string
  default     = null
  description = "(Optional) The Availability Zone which the Virtual Machine should be allocated in, only one zone would be accepted. If set then this module won't create `azurerm_availability_set` resource. Changing this forces a new resource to be created."
}

variable "os_disk" {
  type = object({
    caching                          = string
    storage_account_type             = string
    disk_encryption_set_id           = optional(string)
    disk_size_gb                     = optional(number)
    name                             = optional(string)
    secure_vm_disk_encryption_set_id = optional(string)
    security_encryption_type         = optional(string)
    write_accelerator_enabled        = optional(bool, false)
    diff_disk_settings = optional(object({
      option    = string
      placement = optional(string, "CacheDisk")
    }), null)
  })
  description = <<-EOT
  object({
    caching                          = "(Required) The Type of Caching which should be used for the Internal OS Disk. Possible values are `None`, `ReadOnly` and `ReadWrite`."
    storage_account_type             = "(Required) The Type of Storage Account which should back this the Internal OS Disk. Possible values are `Standard_LRS`, `StandardSSD_LRS`, `Premium_LRS`, `StandardSSD_ZRS` and `Premium_ZRS`. Changing this forces a new resource to be created."
    disk_encryption_set_id           = "(Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. Conflicts with `secure_vm_disk_encryption_set_id`. The Disk Encryption Set must have the `Reader` Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault"
    disk_size_gb                     = "(Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from. If specified this must be equal to or larger than the size of the Image the Virtual Machine is based on. When creating a larger disk than exists in the image you'll need to repartition the disk to use the remaining space."
    name                             = "(Optional) The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created."
    secure_vm_disk_encryption_set_id = "(Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk when the Virtual Machine is a Confidential VM. Conflicts with `disk_encryption_set_id`. Changing this forces a new resource to be created. `secure_vm_disk_encryption_set_id` can only be specified when `security_encryption_type` is set to `DiskWithVMGuestState`."
    security_encryption_type         = "(Optional) Encryption Type when the Virtual Machine is a Confidential VM. Possible values are `VMGuestStateOnly` and `DiskWithVMGuestState`. Changing this forces a new resource to be created. `vtpm_enabled` must be set to `true` when `security_encryption_type` is specified. `encryption_at_host_enabled` cannot be set to `true` when `security_encryption_type` is set to `DiskWithVMGuestState`."
    write_accelerator_enabled        = "(Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to `false`. This requires that the `storage_account_type` is set to `Premium_LRS` and that `caching` is set to `None`."
    diff_disk_settings               = optional(object({
      option    = "(Required) Specifies the Ephemeral Disk Settings for the OS Disk. At this time the only possible value is `Local`. Changing this forces a new resource to be created."
      placement = "(Optional) Specifies where to store the Ephemeral Disk. Possible values are `CacheDisk` and `ResourceDisk`. Defaults to `CacheDisk`. Changing this forces a new resource to be created."
    }), [])
  })
  EOT
  nullable    = false
}
variable "vm_additional_capabilities" {
  type = object({
    ultra_ssd_enabled = optional(bool, false)
  })
  default     = null
  description = <<-EOT
  object({
    ultra_ssd_enabled = "(Optional) Should the capacity to enable Data Disks of the `UltraSSD_LRS` storage account type be supported on this Virtual Machine? Defaults to `false`."
  })
  EOT
}

variable "admin_ssh_key_data" {
  type = any
  default = null
}

variable "enable_boot_diagnostics" {
    type = bool
    default = false
}

variable "gallery_application" {
  type = list(object({
    version_id             = string
    configuration_blob_uri = optional(string)
    order                  = optional(number, 0)
    tag                    = optional(string)
  }))
  default     = []
  description = <<-EOT
  gallery_application = [
    {
    version_id             = "(Required) Specifies the Gallery Application Version resource ID."
    configuration_blob_uri = "(Optional) Specifies the URI to an Azure Blob that will replace the default configuration for the package if provided."
    order                  = "(Optional) Specifies the order in which the packages have to be installed. Possible values are between `0` and `2,147,483,647`."
    tag                    = "(Optional) Specifies a passthrough value for more generic context. This field can be any valid `string` value."
    }
  ]
  EOT
}
variable "storage_account_name" {
      type = string
    default = null
}
variable "identity" {
  type = object({
    type         = string
    identity_ids = optional(set(string))
  })
  default     = null
  description = <<-EOT
  object({
    type         = "(Required) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine. Possible values are `SystemAssigned`, `UserAssigned`, `SystemAssigned, UserAssigned` (to enable both)."
    identity_ids = "(Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine. This is required when `type` is set to `UserAssigned` or `SystemAssigned, UserAssigned`."
  })
  EOT
}

variable "plan" {
  type = object({
    name      = string
    product   = string
    publisher = string
  })
  default     = null
  description = <<-EOT
  object({
    name      = "(Required) Specifies the Name of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created."
    product   = "(Required) Specifies the Product of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created."
    publisher = "(Required) Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from. Changing this forces a new resource to be created."
  })
  EOT
}
variable "secrets" {
  type = list(object({
    key_vault_id = string
    certificate = set(object({
      url   = string
      store = optional(string)
    }))
  }))
  default     = []
  description = <<-EOT
   secrets = [
    {
    key_vault_id = "(Required) The ID of the Key Vault from which all Secrets should be sourced."
    certificate  = set(object({
      url   = "(Required) The Secret URL of a Key Vault Certificate. This can be sourced from the `secret_id` field within the `azurerm_key_vault_certificate` Resource."
      store = "(Optional) The certificate store on the Virtual Machine where the certificate should be added. Required when use with Windows Virtual Machine."
    }
    ]
  EOT
  nullable    = false
}
variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default     = null
  description = <<-EOT
  object({
    publisher = "(Required) Specifies the publisher of the image used to create the virtual machines. Changing this forces a new resource to be created."
    offer     = "(Required) Specifies the offer of the image used to create the virtual machines. Changing this forces a new resource to be created."
    sku       = "(Required) Specifies the SKU of the image used to create the virtual machines. Changing this forces a new resource to be created."
    version   = "(Required) Specifies the version of the image used to create the virtual machines. Changing this forces a new resource to be created."
  })
  EOT
}
variable "termination_notification" {
  type = object({
    enabled = bool
    timeout = optional(string, "PT5M")
  })
  default     = null
  description = <<-EOT
  object({
    enabled = bool
    timeout = optional(string, "PT5M")
  })
  EOT
}

variable "tags" {
  type = map
  description = "key value pair of tags"
  default = {}
}