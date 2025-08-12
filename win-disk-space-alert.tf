data "azurerm_monitor_action_group" "example" {
  resource_group_name = "rg-naveen"
  name                = "ag-alerts-naveen"
}


resource "azurerm_monitor_scheduled_query_rules_alert_v2" "disk_space_alert" {
  name                = "win_disk_space_alert3"
  resource_group_name = azurerm_resource_group.myfirstrg.name
  location            = "centralus"
  scopes              = [data.azurerm_log_analytics_workspace.example.id]
  enabled             = true
  description         = "This is win-disk-space-alert"
  display_name        = "win_disk_space_alert3"
  severity            = 0
  evaluation_frequency = "PT5M"
  window_duration      = "PT5M"
  query_time_range_override = null
  skip_query_validation     = false
  workspace_alerts_storage_enabled = false
  auto_mitigation_enabled = false

  criteria {
    query = <<-QUERY
      Perf
      | where ObjectName == "LogicalDisk"
      | where CounterName == "% Free Space"
      | where InstanceName != "_Total" and InstanceName !contains "HarddiskVolume"
      | summarize arg_max(TimeGenerated, *) by Computer, CounterName, InstanceName
    QUERY

    time_aggregation_method = "Average"
    metric_measure_column   = "CounterValue"
    operator                = "GreaterThan"
    threshold               = 60

    dimension {
      name     = "Computer"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "CounterName"
      operator = "Include"
      values   = ["*"]
    }
    dimension {
      name     = "InstanceName"
      operator = "Include"
      values   = ["*"]
    }

    failing_periods {
      number_of_evaluation_periods    = 1
      minimum_failing_periods_to_trigger_alert = 1
    }
  }

  action {
    action_groups = [data.azurerm_monitor_action_group.example.id]
    # Uncomment to add custom properties or other action types:
    # custom_properties = {}
    # action_properties = {}
  }

  tags = {}
}