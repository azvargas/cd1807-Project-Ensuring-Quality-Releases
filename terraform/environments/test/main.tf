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

module "appservice" {
  source           = "../../modules/appservice"
  location         = "${var.location}"
  application_type = "${var.application_type}"
  resource_type    = "AppService"
  resource_group   = "${module.resource_group.resource_group_name}"
}
