resource "azurerm_virtual_network" "kubespray" {
  name                = var.name.vnet
  location            = azurerm_resource_group.kubespray.location
  resource_group_name = azurerm_resource_group.kubespray.name
  address_space       = [var.cidr]

  tags = {
    environment = "kubespray"
  }
}

