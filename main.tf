resource "azurerm_resource_group" "lab01" {
    name = "lab01-resources"
    location = "eastus2"
}

resource "azurerm_mssql_server" "lab01" {
    name                         = "lab01-sqlserver"
    resource_group_name          = azurerm_resource_group.lab01.name
    location                     = azurerm_resource_group.lab01.location
    version                      = "12.0"
    administrator_login          = "missadministrator"
    administrator_login_password = "AdminPassword123!"
  
}

resource "azurerm_mssql_database" "lab01" {
    name = "lab01-db"
    server_id = azurerm_mssql_server.lab01.id
}

resource "azurerm_mssql_database" "lab02" {
    name = "lab02-db"
    server_id = azurerm_mssql_server.lab01.id
}


resource "azurerm_storage_account" "lab01" {
    name                     = "salab01"
    resource_group_name      = azurerm_resource_group.lab01.name
    location                 = azurerm_resource_group.lab01.location
    account_tier             = "Standard"
    account_replication_type = "LRS" 
  
}

resource "azurerm_mssql_database_extended_auditing_policy" "lab01" {
    database_id                             = azurerm_mssql_database.lab01.id
    storage_endpoint                        = azurerm_storage_account.lab01.primary_blob_endpoint
    storage_account_access_key              = azurerm_storage_account.lab01.primary_access_key
    storage_account_access_key_is_secondary = false
    retention_in_days                       = 30
}

resource "azurerm_sql_firewall_rule" "lab01" {
    name                = "FirewallRule1"
    resource_group_name = azurerm_resource_group.lab01.name
    server_name         = azurerm_mssql_server.lab01.name
    start_ip_address    = ""
    end_ip_address      = ""
  
}
