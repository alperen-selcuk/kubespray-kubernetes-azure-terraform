resource "azurerm_subnet" "kubespray" {
  name                 = var.kubespray.name
  resource_group_name  = azurerm_resource_group.kubespray.name
  virtual_network_name = azurerm_virtual_network.kubespray.name
  address_prefixes     = [var.kubespray.cidr]
}
