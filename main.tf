data "azurerm_resource_group" "resource_group" {
  name = var.resource_group_name
}

resource "azurerm_subnet" "cluster_subnet" {
  name                 = var.subnet_name
  resource_group_name  = data.azurerm_resource_group.resource_group.name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_addres_prefix]

  delegation {
    name = "container-instance"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

resource "random_string" "container_name" {
  length  = 25
  lower   = true
  upper   = false
  special = false
}

resource "azurerm_container_group" "container" {
  name                = "${var.container_group_name_prefix}-${random_string.container_name.result}"
  location            = data.azurerm_resource_group.resource_group.location
  resource_group_name = data.azurerm_resource_group.resource_group.name
  ip_address_type     = "Private"
  subnet_ids          = [azurerm_subnet.cluster_subnet.id]
  os_type             = "Linux"
  restart_policy      = var.restart_policy

  container {
    name   = "${var.container_name_prefix}-${random_string.container_name.result}"
    image  = var.image
    cpu    = var.cpu_cores
    memory = var.memory_in_gb

    ports {
      port     = var.port
      protocol = "TCP"
    }
  }

  depends_on = [azurerm_subnet.cluster_subnet]
}