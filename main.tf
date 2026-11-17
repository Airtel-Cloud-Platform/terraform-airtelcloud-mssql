locals {
  # Deprecated security_group.allowed_ips is merged into custom_cidr so existing callers keep working.
  custom_cidr = distinct(concat(
    var.custom_cidr == null ? [] : var.custom_cidr,
    var.security_group == null ? [] : var.security_group.allowed_ips,
  ))

  has_vpc_and_subnet = var.vpc != null && var.subnet != null
}

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
  custom_cidr               = length(local.custom_cidr) == 0 ? null : local.custom_cidr
  db_name                   = var.db_name
  mssql_username            = var.mssql_username
  password                  = var.password
  labels                    = var.labels
  enable_tde                = var.enable_tde
  advanced_settings_enabled = var.advanced_settings_enabled
  backup = var.backup == null ? null : {
    protection_plan = var.backup.protection_plan
  }

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
    }
  }

  lifecycle {
    precondition {
      condition     = (var.vpc == null) == (var.subnet == null)
      error_message = "vpc and subnet must be set together."
    }

    precondition {
      condition     = length(local.custom_cidr) > 0 || local.has_vpc_and_subnet
      error_message = "Set custom_cidr, or set both vpc and subnet, or set both."
    }
  }
}
