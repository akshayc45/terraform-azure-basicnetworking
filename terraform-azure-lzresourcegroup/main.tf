#Author : Deval Sutaria
# Purpose : this code will create peering connection between vnets. Module is reusable
# No changes to be done in module file
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.2.0"
    }
  }
}
# locals {
# #  time = formatdate("DDMMYYHHmm", timestamp())
# }

############################
###### Resource Group ######
############################

resource "azurerm_resource_group" "azure-lz-sub1rg"{
   for_each = var.resourcegroup 
   name =  each.value.rgname
   location  =  each.value.rglocation
   tags =  merge({"ResourceName" = "${each.value.rgname}"},each.value.tags)
}
output "name" {
  value = local.time
}
