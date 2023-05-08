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

############################
###### Resource Group ######
############################

resource "azurerm_resource_group" "azure-lz-sub1rg"{
   #for_each = var.resourcegroup 
   name =  var.rgname
   location  =  var.location
   tags =  merge({"ResourceName" = var.rgname},
           var.rg_tags
	)
}

############################
####### Route Table ########
############################

# resource "azurerm_route_table" "azure-lz-routeTable"{
#    count = var.Route_Table_name != null ? [1] : 0
#    name =  var.Route_Table_name
#    location  =  azurerm_resource_group.azure-lz-sub1rg.location
#    resource_group_name = azurerm_resource_group.azure-lz-sub1rg.name
#    disable_bgp_route_propagation = var.disable_bgp_route_propagation
#    tags = merge({"ResourceName" = var.Route_Table_name}, var.route_tags)


#     dynamic "route" {
#     for_each = var.route_rule
#     content {
#     name           = route.value["routename"]
#     address_prefix = route.value["address_prefix"]
#     next_hop_type  = route.value["next_hop_type"]
#     next_hop_in_ip_address = route.value["next_hop_type"] != "VirtualAppliance" ?  null : route.value["next_hop_in_ip_address"]
#   }
#     }
#   }


############################
####### VNET-Subnet ########
############################

# data "azurerm_resource_group" "azure-lz-vnet" {
#   name = var.rgname
# }

resource "azurerm_virtual_network" "azure-lz-vnet" {
  name                = var.vnet_name
  resource_group_name = azurerm_resource_group.azure-lz-sub1rg.name
  location            = var.location != null ? var.location : azurerm_resource_group.azure-lz-sub1rg.location
  address_space       = var.address_space
  dns_servers         = var.dns_servers
  tags = merge({"ResourceName" = var.vnet_name}, var.vnet_tags)
 dynamic ddos_protection_plan  {
  for_each = var.ddos_protection_enable ?  [1] : []
   content {
        id = var.ddos_protection_id
        enable = var.ddos_protection_enable 
   }
}
}

resource "azurerm_subnet" "subnet" {
  count                                          = length(var.subnet_names)
  name                                           = var.subnet_names[count.index]
  resource_group_name                            = azurerm_resource_group.azure-lz-sub1rg.name
  virtual_network_name                           = azurerm_virtual_network.azure-lz-vnet.name
  address_prefixes                               = [var.subnet_prefixes[count.index]]
  service_endpoints                              = lookup(var.subnet_service_endpoints, var.subnet_names[count.index], null)
  enforce_private_link_endpoint_network_policies = lookup(var.subnet_enforce_private_link_endpoint_network_policies, var.subnet_names[count.index], false)
  enforce_private_link_service_network_policies  = lookup(var.subnet_enforce_private_link_service_network_policies, var.subnet_names[count.index], false)

  dynamic "delegation" {
    for_each = lookup(var.subnet_delegation, var.subnet_names[count.index], {})
    content {
      name = delegation.key
      service_delegation {
        name    = lookup(delegation.value, "service_name")
        actions = lookup(delegation.value, "service_actions", [])
      }
    }
  }
}

locals {
  azurerm_subnets = {
    for index, subnet in azurerm_subnet.subnet :
    subnet.name => subnet.id
  }
}

resource "azurerm_subnet_network_security_group_association" "azure-lz-vnet" {
  for_each                  = var.nsg_ids
  subnet_id                 = local.azurerm_subnets[each.key]
  network_security_group_id = each.value
}

resource "azurerm_subnet_route_table_association" "azure-lz-vnet" {
  for_each       = var.route_tables_ids
  route_table_id = each.value == "" ? azurerm_route_table.azure-lz-routeTable.id : each.value
  subnet_id      = local.azurerm_subnets[each.key] 
}

# ###########################
# ###### VNET Peering #######
# ###########################

# data "azurerm_subscription" "current" {}

# locals {
#   subscription_id_1 = var.subscription_ids[0]
#   #subscription_id_2 = var.subscription_ids[1]
# }

# provider "azurerm" {
#   features {
    
#   }
#   alias           = "sub1"
#   subscription_id = "${local.subscription_id_1}"
# }

# provider "azurerm" {
#   features {
    
#   }
#   alias           = "sub2"
#   subscription_id = "${local.subscription_id_1}"
# }

# data "azurerm_resource_group" "rg1" {
#   provider = azurerm.sub1
#   name     = "${var.resource_group_names[0]}"
# }

# data "azurerm_virtual_network" "vnet1" {
#   provider            = azurerm.sub1
#   name                = "${var.vnet_names[0]}"
#   resource_group_name = "${data.azurerm_resource_group.rg1.name}"
# }

# resource "azurerm_virtual_network_peering" "vnet_peer_1" {
#   provider            = azurerm.sub1
#   name                         = "${var.vnet_peering_names[0]}"
#   resource_group_name          = "${data.azurerm_resource_group.rg1.name}"
#   virtual_network_name         = "${data.azurerm_virtual_network.vnet1.name}"
#   remote_virtual_network_id    = "${azurerm_virtual_network.azure-lz-vnet.id}"
#  # remote_virtual_network_id = var.vnet_id_2
#   allow_virtual_network_access = "${var.allow_virtual_network_access}"
#   allow_forwarded_traffic      = "${var.allow_forwarded_traffic}"
#   use_remote_gateways          = "${var.use_remote_gateways1}"
#   allow_gateway_transit        = "${var.allow_gateway_transit}"
# }

# resource "azurerm_virtual_network_peering" "vnet_peer_2" {
#   provider            = azurerm.sub2
#   name                         = "${var.vnet_peering_names[1]}"
#   #resource_group_name          = "${data.azurerm_resource_group.rg2.name}"
#   resource_group_name          = azurerm_resource_group.azure-lz-sub1rg.name
#   virtual_network_name         = "${var.vnet_names[1]}"
#   remote_virtual_network_id    = "${data.azurerm_virtual_network.vnet1.id}"
#   allow_virtual_network_access = "${var.allow_virtual_network_access}"
#   allow_forwarded_traffic      = "${var.allow_forwarded_traffic}"
#   use_remote_gateways          = "${var.use_remote_gateways2}"
# }



