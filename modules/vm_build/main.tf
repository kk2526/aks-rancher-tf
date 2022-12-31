locals {
  elk_rg_name = upper("${var.name_prefix}-${var.product}-${var.environment}-${var.location_label}-ELK-RG")
  elk_vm_name = upper("${var.name_prefix}-${var.product}-${var.environment}-${var.location_label}-ELK-VM")
  tags        = { Environment = upper(var.environment) }
}

resource "azurerm_resource_group" "elk_rg" {
  name     = local.elk_rg_name
  location = var.location
  tags     = local.tags
  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_network_interface" "elk_nic" {
  name                = lower("${var.name_prefix}-${var.product}-${var.environment}-${var.location_label}-elk498")
  location            = azurerm_resource_group.elk_rg.location
  resource_group_name = azurerm_resource_group.elk_rg.name
  tags                = local.tags
  lifecycle { ignore_changes = [tags] }
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "elk_virtual_machine" {
  name                            = local.elk_vm_name
  location                        = var.location
  resource_group_name             = azurerm_resource_group.elk_rg.name
  size                            = var.elk_vm_size
  disable_password_authentication = false
  admin_username                  = var.elk_credential_user
  admin_password                  = var.elk_credential_password
  provision_vm_agent              = true
  # TODO: Enable accelerated networking if supported by the chosen VM size
  # enable_accelerated_networking = true
  # proximity_placement_group_id    = var.proximity_placement_group_id
  network_interface_ids = [azurerm_network_interface.elk_nic.id]
  source_image_reference {
    publisher = var.elk_publisher
    offer     = var.elk_offer
    sku       = var.elk_sku
    version   = var.elk_version
  }
  identity {
    type = "SystemAssigned"
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }
  plan {
    name      = var.elk_sku
    product   = var.elk_offer
    publisher = var.elk_publisher
  }
  tags = local.tags

  #Terraform should not be responsible for syncronizing secrets, so we ignore KeyVault changes to the username or password for this resource.
  lifecycle {
    ignore_changes = [
      admin_username,
      admin_password,
      tags
    ]
  }
}

resource "azurerm_virtual_machine_extension" "azure_monitor_agent" {
  name                       = "AzureMonitorLinuxAgent"
  virtual_machine_id         = azurerm_linux_virtual_machine.elk_virtual_machine.id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.6"
  auto_upgrade_minor_version = true

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}

resource "azurerm_virtual_machine_extension" "elasticsearch_config_update" {
  name                 = "UpdateElasticNetworkConfig"
  virtual_machine_id   = azurerm_linux_virtual_machine.elk_virtual_machine.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.1"
  tags                 = local.tags
  settings             = <<SETTINGS
    {
        "script": "${filebase64("./vm_deployment_scripts/elk_config.sh")}"
    }
SETTINGS

  lifecycle {
    ignore_changes = [
      tags
    ]
  }
}
