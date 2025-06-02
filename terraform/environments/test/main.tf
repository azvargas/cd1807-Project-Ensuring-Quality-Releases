# This configuration is for running from an Azure DevOps pipeline with a Service Connection configured.
provider "azurerm" {
  features {}
  subscription_id                    = "${var.subscription_id}"
  ado_pipeline_service_connection_id = "5a89ef70-22ee-42d8-9103-6aafe9b1e6ec"
}

# To run manually from the console, the provider block needs to have all the elements.
# Also, the Azure CLI should be installed and logged in.
# provider "azurerm" {
#   tenant_id       = "${var.tenant_id}"
#   subscription_id = "${var.subscription_id}"
#   client_id       = "${var.client_id}"
#   client_secret   = "${var.client_secret}"
#   features {}
# }

# The backend is configured in the pipeline. To run locally, the block should have the properties filled.
terraform {
  backend "azurerm" {
#    storage_account_name = "tfstate45611955"
#    container_name       = "tfstate"
#    key                  = "test.terraform.tfstate"
#    access_key           = ""
  }
}

module "resource_group" {
  source               = "../../modules/resource_group"
  resource_group       = "${var.resource_group}"
  location             = "${var.location}"
}

module "network" {
  source               = "../../modules/network"
  address_space        = "${var.address_space}"
  location             = "${var.location}"
  virtual_network_name = "${var.virtual_network_name}"
  application_type     = "${var.application_type}"
  resource_type        = "NET"
  resource_group       = "${module.resource_group.resource_group_name}"
  address_prefix_test  = "${var.address_prefix_test}"
}

module "nsg-test" {
  source           = "../../modules/networksecuritygroup"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "NSG"
  resource_group   = "${module.resource_group.resource_group_name}"
  subnet_id        = "${module.network.subnet_id_test}"
  address_prefix_test = "${var.address_prefix_test}"
  address_prefix_for_nsg = "${var.address_prefix_for_nsg}"
}

module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}

module "publicip" {
  source           = "../../modules/publicip"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "publicip"
  resource_group   = "${module.resource_group.resource_group_name}"
}

module "vm" {
  source               = "../../modules/vm"
  location             = "${var.location}"
  application_type     = "${var.application_type}"
  resource_type        = "VM"
  resource_group       = "${module.resource_group.resource_group_name}"
  subnet_id            = "${module.network.subnet_id_test}"
  public_ip_address_id = "${module.publicip.public_ip_address_id}"
}

module "metric_alert" {
  source = "../../modules/metric_alert"
  application_type = "${var.application_type}"
  resource_type = "Alert"
  resource_group = "${module.resource_group.resource_group_name}"
  webapp_id = "${module.appservice.app_service_id}"
}