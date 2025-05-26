# If this script will run using a Udacity subscription, the "data" object defined below should be used
# instead of the "resource" object, as Udacity does not allow the creation os new resource groups.

#resource "azurerm_resource_group" "test" {
#  name     = "${var.resource_group}"
#  location = "${var.location}"
#}

data "azurerm_resource_group" "test" {
  name     = "${var.resource_group}"
#  location = "${var.location}"
}