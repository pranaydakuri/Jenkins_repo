provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Configure the Terraform backend to use Azure Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "tfstate-rg"
    storage_account_name = "tfstatestorage8247"  # Match the storage account name above
    container_name       = "tfstate"
    key                  = "KEY"
  }
}

resource "azurerm_resource_group" "example" {
  name     = "example"
  location = "East US"
}

resource "azurerm_virtual_network" "VNET1" {
  name                = "VNET1"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "SUBNET1" {
  name                 = "SUBNET1"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.VNET1.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "NF" {
  name                = "NF"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.SUBNET1.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "VM1" {
  name                  = "VM1"
  resource_group_name   = azurerm_resource_group.example.name
  location              = azurerm_resource_group.example.location
  size                  = "Standard_B1s" # Choose the VM size suitable for your workload
  admin_username        = "pranayvm"
  admin_password        = "P@ssw0rd1234!" # Replace with a strong password
  disable_password_authentication = false # Allow password authentication
  network_interface_ids = [azurerm_network_interface.NF.id]

os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    name                 = "osdisk1"
    disk_size_gb         = 30 # Adjust the disk size as needed
  }

  source_image_reference {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-focal"
  sku       = "20_04-lts-gen2"
  version   = "latest"
}

  computer_name = "linuxvm"
}
output "vm_public_ip" {
  value = azurerm_network_interface.NF.ip_configuration[0].private_ip_address
}
