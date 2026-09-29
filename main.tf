resource "airtelcloud_mssql" "this" {
  name                      = var.name
  description               = var.description
  database_edition          = var.database_edition
  collation                 = var.collation
  features                  = var.features
  compute_size              = var.compute_size
  storage_size              = var.storage_size
  storage_type              = var.storage_type
  availability_zone         = var.availability_zone
  vpc                       = var.vpc
  subnet                    = var.subnet
  db_name                   = var.db_name
  mssql_username            = var.mssql_username
  password                  = var.password
  labels                    = var.labels
  enable_tde                = var.enable_tde
  advanced_settings_enabled = var.advanced_settings_enabled
  backup = var.backup == null ? null : {
    protection_plan = var.backup.protection_plan
  }
  security_group = var.security_group == null ? null : {
    allowed_ips = var.security_group.allowed_ips
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}
