data "azurerm_shared_image_gallery" "test" {
  name                = "TestVMsGallery"
  resource_group_name = "${var.resource_group}"
}

data "azurerm_shared_image" "test" {
  name                = "LinuxTestVM"
  gallery_name        = data.azurerm_shared_image_gallery.test.name
  resource_group_name = "${var.resource_group}"
  identifier {
    publisher = "canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
  }
}

resource "azurerm_network_interface" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${var.public_ip_address_id}"
  }
}

resource "azurerm_linux_virtual_machine" "test" {
  name                = "${var.application_type}-${var.resource_type}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group}"
  size                = "Standard_B1ls_v2"
  admin_username      = "udacityadmin"
  network_interface_ids = [azurerm_network_interface.test.id]
  admin_ssh_key {
    username   = "udacityadmin"
    public_key = file("./id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_id = data.azurerm_shared_image.test.id
}
