resource "azurerm_resource_group" "resourceGroup" {
  location = var.location
  name = join("-",[var.prefix,"rg"])
}

resource "azurerm_virtual_network" "virtualNetwork" {
  depends_on=[azurerm_resource_group.resourceGroup]

  name                = join("",var.prefix,"Vnet")
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.resourceGroup.name
}

resource "azurerm_subnet" "subNet" {
  depends_on=[azurerm_virtual_network.virtualNetwork]

  name                 = join("",var.prefix,"subNet")
  resource_group_name  = azurerm_resource_group.resourceGroup.name
  virtual_network_name = azurerm_virtual_network.virtualNetwork.name
  address_prefix       = "10.0.2.0/24"
}

resource "azurerm_public_ip" "publicIP" {
    depends_on=[azurerm_resource_group.resourceGroup]

    name                         = join("",var.prefix,"PIP")
    location                     = var.location
    resource_group_name          = azurerm_resource_group.resourceGroup.name
    allocation_method            = "Static"
}

resource "azurerm_network_security_group" "networkSecurityGroup" {
    depends_on=[azurerm_resource_group.resourceGroup]

    name                = join("",var.prefix,"NSG")
    location            = var.location
    resource_group_name = azurerm_resource_group.resourceGroup.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_security_rule" "accessWebapp" {
  depends_on=[azurerm_resource_group.resourceGroup,azurerm_network_security_group.networkSecurityGroup]

  name = "Port_8080"
  priority = 100
  direction = "Inbound"
  access = "Allow"
  protocol = "Tcp"
  source_port_range = "*"
  destination_port_range = "8080"
  source_address_prefix = "*"
  destination_address_prefix = "*"
  resource_group_name = azurerm_resource_group.resourceGroup.name
  network_security_group_name = azurerm_network_security_group.networkSecurityGroup.name
}

resource "azurerm_network_interface" "nic" {
  depends_on                = [azurerm_subnet.subNet,azurerm_public_ip.publicIP]

  name                      = join("",var.prefix,"NIC")
  location                  = var.location
  resource_group_name       = azurerm_resource_group.resourceGroup.name

  ip_configuration {
    name                          = "ipconfig"
    subnet_id                     = azurerm_subnet.subNet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.publicIP.id
  }
}


resource "azurerm_network_interface_security_group_association" "nisga" {
    depends_on                = [azurerm_network_interface.nic,azurerm_network_security_group.networkSecurityGroup]

    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.networkSecurityGroup.id
}


resource "azurerm_virtual_machine" "virtual-machine" {
    depends_on            = [azurerm_network_interface.nic]

    name                  = join("",var.prefix,"vm")
    location              = var.location
    resource_group_name   = azurerm_resource_group.resourceGroup.name
    vm_size               = "Basic_A1"
    network_interface_ids = [azurerm_network_interface.nic.id]


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name         = "ubuntu"
    admin_username        = "prod-webapp"
    admin_password        = "prodwebapp@123"
    custom_data           = file("initial-boot.txt")
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}