output "id" {
  description = "UUID of the MSSQL instance."
  value       = airtelcloud_mssql.this.id
}

output "name" {
  description = "Configured instance name."
  value       = airtelcloud_mssql.this.name
}

output "version" {
  description = "Database version resolved from the selected edition."
  value       = airtelcloud_mssql.this.version
}

output "db_name" {
  description = "Initial database name."
  value       = airtelcloud_mssql.this.db_name
}

output "mssql_username" {
  description = "Admin username."
  value       = airtelcloud_mssql.this.mssql_username
}

output "status" {
  description = "Current instance status."
  value       = airtelcloud_mssql.this.status
}

output "availability_zone" {
  description = "Availability zone of the instance."
  value       = airtelcloud_mssql.this.availability_zone
}

output "port" {
  description = "Database port returned by the API."
  value       = airtelcloud_mssql.this.port
}

output "created_at" {
  description = "Creation timestamp of the instance."
  value       = airtelcloud_mssql.this.created_at
}

output "connection_string" {
  description = "MSSQL connection string. Sensitive. Empty until the API returns one."
  value       = airtelcloud_mssql.this.connection_string
  sensitive   = true
}

output "vpc" {
  description = "VPC name from the configuration. Null when only custom_cidr is used, and after import."
  value       = airtelcloud_mssql.this.vpc
}

output "subnet" {
  description = "Subnet name from the configuration. Null when only custom_cidr is used, and after import."
  value       = airtelcloud_mssql.this.subnet
}

output "custom_cidr" {
  description = "Custom CIDR blocks from the configuration, including any from the deprecated security_group. Null when none are set."
  value       = airtelcloud_mssql.this.custom_cidr
}

output "mssql" {
  description = "Selected instance attributes for downstream modules."

  value = {
    id                = airtelcloud_mssql.this.id
    name              = airtelcloud_mssql.this.name
    version           = airtelcloud_mssql.this.version
    db_name           = airtelcloud_mssql.this.db_name
    mssql_username    = airtelcloud_mssql.this.mssql_username
    status            = airtelcloud_mssql.this.status
    availability_zone = airtelcloud_mssql.this.availability_zone
    port              = airtelcloud_mssql.this.port
    created_at        = airtelcloud_mssql.this.created_at
    connection_string = airtelcloud_mssql.this.connection_string
    vpc               = airtelcloud_mssql.this.vpc
    subnet            = airtelcloud_mssql.this.subnet
    custom_cidr       = airtelcloud_mssql.this.custom_cidr
  }
}
