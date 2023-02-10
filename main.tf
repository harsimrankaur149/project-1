resource "azuread_user" "trainee_user" {
 user_principal_name = "harsimranjitkaur@hashicorp.com"
  display_name        = "Harsimranjit Kaur"
}

resource "azuread_user" "trainer_user" {
  user_principal_name = "ibrahimozbekler@hashicorp.com"
  display_name        = "Ibrahim Ozbekler"
  force_password_change = true
}

resource "aws_iam_user" "classmates_users" {
  for_each = toset(var.users)
  name     = each.value
}

resource "aws_s3_bucket" "myprojectbucket" {
 count = length(var.s3bucket_names)
  bucket = var.s3bucket_names[count.index]

  tags = {
    Name        = "bucket"
    Environment = "Dev"
  }
}



resource "azurerm_resource_group" "project" {
  name     = var.name
  location = var.location
  
}

resource "azurerm_virtual_network" "mainnetwork" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.project.name
  virtual_network_name = azurerm_virtual_network.mainnetwork.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "maininterface" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.project.location
  resource_group_name = azurerm_resource_group.project.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "mainvirtualmachine" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.project.location
  resource_group_name   = azurerm_resource_group.project.name
  network_interface_ids = [azurerm_network_interface.maininterface.id]
  vm_size               = "Standard_DS1_v2"


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_account" "project_account_for_storage" {
  name                     = "projectstorageacc"
  resource_group_name      = azurerm_resource_group.project.name
  location                 = azurerm_resource_group.project.location
  account_tier             = "Standard"
  account_replication_type = "GRS"

  tags = {
    name = "project storage account"
    environment = "staging"
  }
}