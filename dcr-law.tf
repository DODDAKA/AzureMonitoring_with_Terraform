data "azurerm_log_analytics_workspace" "example" {
  name                = "law-monitoring"
  resource_group_name = "rg-naveen"
}

resource "azurerm_monitor_data_collection_rule" "dcr_vm_insights" {
  name                = var.data_collection_rules_dcr_vm_insights_name
  location            = "centralus"
  resource_group_name = azurerm_resource_group.myfirstrg.name
  kind                = "Windows"

  destinations {
    log_analytics {
      workspace_resource_id = data.azurerm_log_analytics_workspace.example.id
      name                 = "law-monitoring"
    }
  }

  data_flow {
    streams      = ["Microsoft-Perf"]
    destinations = ["law-monitoring"]
    transform_kql = "source"
    output_stream = "Microsoft-Perf"
  }

  data_sources {
    performance_counter {
      streams                       = ["Microsoft-Perf"]
      sampling_frequency_in_seconds = 60
      counter_specifiers            = ["\\LogicalDisk(*)\\% Free Space"]  ###\LogicalDisk(*)\% Free Space
      name                          = "perfCounterDataSource60"
    }
  }
}

data "azurerm_virtual_machine" "example" {
  name                = "vmnaveen"
  resource_group_name = "rg-naveen"
}

# associate to a Data Collection Rule
resource "azurerm_monitor_data_collection_rule_association" "example1" {
  name                    = "example1-dcra"
  target_resource_id      = data.azurerm_virtual_machine.example.id
  data_collection_rule_id = azurerm_monitor_data_collection_rule.dcr_vm_insights.id
  description             = "example"
}