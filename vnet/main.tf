resource "azurerm_resource_group" "myResourceGroup" {
  name     = "myResourceGroup"
  location = "East US 2"
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = [var.address_space]
  location            = "East US 2"
  resource_group_name = "myResourceGroup"

  dynamic "subnet" {
    for_each = var.subnets
    content {
      name           = subnet.value.name
      address_prefix = subnet.value.prefix
    }
  }
  depends_on = [ azurerm_resource_group.myResourceGroup ]
}