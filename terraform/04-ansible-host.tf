resource "azurerm_network_interface" "ansible" {
  name                = "ansible-nic"
  location            = azurerm_resource_group.kubespray.location
  resource_group_name = azurerm_resource_group.kubespray.name
  

  ip_configuration {
    name                          = "ansible"
    subnet_id                     = azurerm_subnet.kubespray.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.ansible.id
  }
  
}

resource "azurerm_public_ip" "ansible" {
  name                = "ansible"
  resource_group_name = azurerm_resource_group.kubespray.name
  location            = azurerm_resource_group.kubespray.location
  allocation_method   = "Static"
  sku = "Standard"

  tags = {
    environment = "kubespray"
  }
}


resource "azurerm_linux_virtual_machine" "ansible" {
  name                = "ansible-vm"
  location              = azurerm_resource_group.kubespray.location
  resource_group_name   = azurerm_resource_group.kubespray.name
  network_interface_ids = [azurerm_network_interface.ansible.id]
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

  depends_on = [ local_file.ssh-key ]
}


resource "azurerm_network_security_group" "kubespray" {
  name                = "ansible-nsg"
  location            = azurerm_resource_group.kubespray.location
  resource_group_name = azurerm_resource_group.kubespray.name

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "kubespray"
  }
}

resource "azurerm_network_interface_security_group_association" "kubespray_nsg_association" {
  count                     = 3
  network_interface_id       = azurerm_network_interface.kubespray[count.index].id
  network_security_group_id  = azurerm_network_security_group.kubespray.id
}

resource "azurerm_network_interface_security_group_association" "ansible_nsg_association" {
  network_interface_id       = azurerm_network_interface.ansible.id
  network_security_group_id  = azurerm_network_security_group.kubespray.id
}