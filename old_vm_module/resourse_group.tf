resource "azurerm_resource_group" "My-First-tf-resource" {
  name     = var.rg_name
  location = var.location
}

resource "azurerm_virtual_network" "Vnet-1" {
  name                = var.vnet
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.rg_name
}

resource "azurerm_subnet" "subnet-1" {
  name                 = "subnet-1"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet
  address_prefixes     = var.address_subnet_1
}

resource "azurerm_subnet" "subnet-2" {
  name                 = "subnet-2"
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet
  address_prefixes     = var.address_subnet_2
}

resource "azurerm_public_ip" "public_ip" {
  name                = "Linux01_public_ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
}
resource "azurerm_public_ip" "win_public_ip" {
  name                = "Windows01_public_ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
}
resource "azurerm_network_interface" "tf-nic-1" {
  name                = "tf-nic-1"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.Linux01_public_ip.id
  }
}
resource "azurerm_network_interface" "tf-nic-2" {
  name                = "tf-nic-2"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet-2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.win_public_ip.id
    
  }
}
resource "azurerm_linux_virtual_machine" "my-tf-linux01" {
  name                            = var.Linux_vm
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = "adminuser"
  admin_password                  = "%1XPAQ5gqNA8"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.tf-nic-1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = var.Linux_disk
    
  }

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }
}
resource "azurerm_public_ip" "Linux01_public_ip" {
  name                = "Linux01_public_ip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
}

resource "azurerm_windows_virtual_machine" "my-tf-windows01" {
  name                            = var.Windows_vm
  resource_group_name             = var.rg_name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = "adminuser"
  admin_password                  = "%1XPAQ5gqNA8"
   network_interface_ids = [
    azurerm_network_interface.tf-nic-2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = var.Windows_disk
      
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
    
  }
  
}
output "Windows_vm_name" {
  value =azurerm_windows_virtual_machine.my-tf-windows01.computer_name
}
output "Windows_public_ip" {
  value =azurerm_windows_virtual_machine.my-tf-windows01.public_ip_address
}
output "Windows_private_ip" {
  value =azurerm_windows_virtual_machine.my-tf-windows01.private_ip_address
}
output "Linux_vm_name" {
  value =azurerm_linux_virtual_machine.my-tf-linux01.computer_name
}
output "Linux_public_ip" {
  value =azurerm_linux_virtual_machine.my-tf-linux01.public_ip_address
}
output "Linux_private_ip" {
  value =azurerm_linux_virtual_machine.my-tf-linux01.private_ip_address
}