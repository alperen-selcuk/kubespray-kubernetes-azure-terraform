output "ansible" {
  value = azurerm_public_ip.ansible.ip_address
}

output "kubespray_ips" {
  value = [for nic in azurerm_network_interface.kubespray : nic.private_ip_address]
}
