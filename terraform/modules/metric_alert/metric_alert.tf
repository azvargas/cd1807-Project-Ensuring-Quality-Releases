resource "azurerm_monitor_action_group" "test" {
    name                = "${var.application_type}-${var.resource_type}-Action"
    resource_group_name = "${var.resource_group}"
    short_name          = "Notification"

    email_receiver {
        name          = "sendtoowner"
        email_address = "factronic_cloud@outlook.com"
    }
}

resource "azurerm_monitor_metric_alert" "test" {
    name                = "${var.application_type}-${var.resource_type}"
    resource_group_name = "${var.resource_group}"
    scopes              = [ "${var.webapp_id}" ]
    description         = "Notify if concurrent connections reach 20 or more"
    frequency           = "PT1M"

    criteria {
        metric_namespace = "Microsoft.Web/sites"
        metric_name      = "Http2xx"
        aggregation      = "Total"
        operator         = "GreaterThan"
        threshold        = 20
    }

    action {
        action_group_id = azurerm_monitor_action_group.test.id
    }
}