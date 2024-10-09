resource "azurerm_network_interface" "kubespray" {
  count = 3
  name                = "kubespray-nic-${count.index + 1}"
  location            = azurerm_resource_group.kubespray.location
  resource_group_name = azurerm_resource_group.kubespray.name

  ip_configuration {
    name                          = "ansible"
    subnet_id                     = azurerm_subnet.kubespray.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "kubespray" {
  count               = 3
  name                = "kubespray-vm-${count.index + 1}"
  location            = azurerm_resource_group.kubespray.location
  resource_group_name = azurerm_resource_group.kubespray.name
  network_interface_ids = [
    azurerm_network_interface.kubespray[count.index].id
  ]
  size                = "Standard_B2ms"
  admin_username      = "ansible"

  admin_ssh_key {
    username   = "ansible"
    public_key = tls_private_key.ssh-key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  depends_on = [local_file.ssh-key]
}
