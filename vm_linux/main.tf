resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.resource_group_location

  tags = {
    environment = "production"
  }
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.virtual_network_name
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = "production"
  }
}


resource "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_public_ip" "public_ip" {
  name                = var.public_ip_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic" #static 

  tags = {
    environment = "production"
  }
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.network_security_group_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp" #udp or * (matchs all)
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "production"
  }
}


resource "azurerm_network_interface" "nic" {
  name                = var.network_interface_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }

  tags = {
    environment = "production"
  }
}


resource "azurerm_network_interface_security_group_association" "association" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# Generate random text for a unique storage account name

resource "random_id" "randomId" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}


resource "azurerm_storage_account" "storage" {
  name                     = "${random_id.randomId.hex}"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard" #Premium
  account_replication_type = "LRS" #LRS, GRS, RAGRS, ZRS, GZRS and RAGZRS

  tags = {
    environment = "production"
  }
}


resource "tls_private_key" "example_ssh" {
  algorithm = "RSA" #RSA, ECDSA, ED25519.
  rsa_bits  = 4096

}


resource "azurerm_linux_virtual_machine" "linuxvm" {
  name                  = var.linux_virtual_machine_name
  location              = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size                  = "Standard_DS1_v2" #Standard is recommended tier D – General purpose compute 
                                             #S – Can use Premium Storage and offers a local SSD disk 
                                             #cache 1 – VM Size v2 

  os_disk {
    name                 = "myOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS" #StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. 
  }
   #operating system
  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "myvm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
  }

  tags = {
    environment = "production"
  }
}