resource "azurerm_resource_group" "Vegetagrp" {
  name     = "Vegeta-grp"
  location = local.resource_location
}

resource "azurerm_virtual_network" "goku_network" {
  name                = local.virtual_network.name
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.Vegetagrp.name
  address_space       = local.virtual_network.address_prefixes
}

resource "azurerm_subnet" "gohansubnet01" {
  name                 = local.subnets[0].name
  resource_group_name  = azurerm_resource_group.Vegetagrp.name
  virtual_network_name = azurerm_virtual_network.goku_network.name
  address_prefixes     = local.subnets[0].address_prefixes
}

resource "azurerm_subnet" "gotensubnet01" {
  name                 = local.subnets[1].name
  resource_group_name  = azurerm_resource_group.Vegetagrp.name
  virtual_network_name = azurerm_virtual_network.goku_network.name
  address_prefixes     = local.subnets[1].address_prefixes
}

resource "azurerm_network_interface" "gohaninterface01" {
  name                = "gohaninterface01"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.Vegetagrp.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.gohansubnet01.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.gohanip01.id
  }
}

output "gohansubnet01_id" {
  value = azurerm_subnet.gohansubnet01.id
}

resource "azurerm_public_ip" "gohanip01" {
  name                = "gohanip01"
  resource_group_name = azurerm_resource_group.Vegetagrp.name
  location            = local.resource_location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_security_group" "piccolo" {
  name                = "piccolo"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.Vegetagrp.name

  security_rule {
    name                       = "AllowRDP"
    priority                   = 300
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}

  resource "azurerm_subnet_network_security_group_association" "gohansubnet01_nsg" {
  subnet_id                 = azurerm_subnet.gohansubnet01.id
  network_security_group_id = azurerm_network_security_group.piccolo.id
}

resource "azurerm_subnet_network_security_group_association" "gotensubnet01_nsg" {
  subnet_id                 = azurerm_subnet.gotensubnet01.id
  network_security_group_id = azurerm_network_security_group.piccolo.id
}

resource "azurerm_windows_virtual_machine" "krillinweb" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.Vegetagrp.name
  location            = local.resource_location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.gohaninterface01.id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "dd_disk" {
  name                 = var.disk_name
  location             = local.resource_location
  resource_group_name  = azurerm_resource_group.Vegetagrp.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "4"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "dd_disk_krillinweb" {
  managed_disk_id    = azurerm_managed_disk.dd_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.krillinweb.id
  lun                = "10"
  caching            = "ReadWrite"
}
