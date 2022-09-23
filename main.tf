terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}
provider "azurerm" {
  features {}
    subscription_id   = "c5753d72-28fc-43d8-ab70-1c7a04af209e"
    tenant_id         = "f89944b7-4a4e-4ea7-9156-3299f3411647"
    client_secret     = "MZI8Q~Jb~E8aQdR7HkqMkaQwG3by7WV4L_dvPc4G"
    client_id         = "fa0d2a1e-ca0d-4f81-88d0-10a7e696e607"
}
resource "azurerm_resource_group" "resourcegroup" {
  name     = "${var.rgname}"
  location = "${var.rglocation}"
}
resource "azurerm_storage_account" "saname" {
  name                     = "${var.storagename}"
  resource_group_name      = azurerm_resource_group.resourcegroup.name
  location                 = azurerm_resource_group.resourcegroup.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  }
resource "azurerm_virtual_network" "virtualnet" {
  name                = "${var.prefix}"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  address_space       = ["${var.vnet_cidr_prefix}"]
}
resource "azurerm_subnet" "subnetf" {
  name                 = "subnettf"
  resource_group_name  = azurerm_resource_group.resourcegroup.name
  virtual_network_name = azurerm_virtual_network.virtualnet.name
  address_prefixes     = ["${var.subnettf_cidr_prefix}"]
}
resource "azurerm_network_interface" "ani" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnetf.id
    private_ip_address_allocation = "Dynamic"
  }
}
resource "azurerm_linux_virtual_machine" "tfmachine" {
  name                = "${var.prefix}-vmtf"
  resource_group_name = azurerm_resource_group.resourcegroup.name
  location            = azurerm_resource_group.resourcegroup.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "Knreddy339191"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.ani.id,
  ]
  #admin_ssh_key {
    #username   = "adminuser"
    #public_key = file("~/.ssh/id_rsa.pub")
  #}
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
}
resource "azurerm_app_service_plan" "tfappserviceplan" {
  name                = "${var.appserviceplan}-appserviceplan"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name

  sku {
    tier = "Standard"
    size = "S1"
  }
}
resource "azurerm_app_service" "tfapp" {
  name                = "${var.appservice}-app-service"
  location            = azurerm_resource_group.resourcegroup.location
  resource_group_name = azurerm_resource_group.resourcegroup.name
  app_service_plan_id = azurerm_app_service_plan.tfappserviceplan.id
}