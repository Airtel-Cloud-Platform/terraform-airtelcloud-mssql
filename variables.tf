#########################################
# Identity
#########################################

variable "name" {
  description = "Instance name. Forces a new resource."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.name))
    error_message = "name must contain only lowercase letters, digits, and hyphens."
  }
}

variable "description" {
  description = "Instance description. Forces a new resource."
  type        = string
  default     = "Managed by Terraform"
}

variable "database_edition" {
  description = "Database edition, such as web, standard, or enterprise. Version is taken from that edition. Forces a new resource."
  type        = string

  validation {
    condition     = length(trim(var.database_edition, " ")) > 0
    error_message = "database_edition cannot be empty."
  }
}

variable "collation" {
  description = "Collation name from the catalog for the selected edition. Forces a new resource."
  type        = string

  validation {
    condition     = length(trim(var.collation, " ")) > 0
    error_message = "collation cannot be empty."
  }
}

variable "features" {
  description = "Feature values for the collation, such as SQLENGINE. Each value must be offered for the selected edition. Forces a new resource."
  type        = list(string)

  validation {
    condition     = length(var.features) > 0
    error_message = "features must contain at least one value."
  }

  validation {
    condition     = length(var.features) == length(distinct(var.features))
    error_message = "features cannot contain duplicate values."
  }
}

#########################################
# Database credentials
#########################################

variable "db_name" {
  description = "Initial database name. Forces a new resource."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]*$", var.db_name))
    error_message = "db_name must start with a letter and contain only letters, digits, and underscore."
  }
}

variable "mssql_username" {
  description = "Admin username. Forces a new resource."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z][A-Za-z0-9_]*$", var.mssql_username))
    error_message = "mssql_username must start with a letter and contain only letters, digits, and underscore."
  }
}

variable "password" {
  description = "Admin password. Stored in Terraform state; the API does not return it. The same value is sent as confirm_password. Forces a new resource."
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.password) > 0
    error_message = "password cannot be empty."
  }
}

#########################################
# Sizing and placement
#########################################

variable "compute_size" {
  description = "Flavor name from the MSSQL flavors catalog for the selected edition. Forces a new resource."
  type        = string

  validation {
    condition     = length(trim(var.compute_size, " ")) > 0
    error_message = "compute_size cannot be empty."
  }
}

variable "storage_size" {
  description = "Storage size in GiB. Must be from 200 to 2048 in steps of 10 starting at 200. Forces a new resource."
  type        = number

  validation {
    condition     = var.storage_size >= 200 && var.storage_size <= 2048 && (var.storage_size - 200) % 10 == 0
    error_message = "storage_size must be from 200 to 2048 GiB in steps of 10 starting at 200."
  }
}

variable "storage_type" {
  description = "Volume type label. Defaults to High Performance. Forces a new resource."
  type        = string
  default     = "High Performance"
}

variable "availability_zone" {
  description = "Availability zone code, such as S1. Forces a new resource."
  type        = string

  validation {
    condition     = length(trim(var.availability_zone, " ")) > 0
    error_message = "availability_zone cannot be empty."
  }
}

variable "vpc" {
  description = "VPC name stored for later use. Not sent to the API. Forces a new resource."
  type        = string

  validation {
    condition     = length(trim(var.vpc, " ")) > 0
    error_message = "vpc cannot be empty."
  }
}

variable "subnet" {
  description = "Subnet name stored for later use. Not sent to the API. Forces a new resource."
  type        = string

  validation {
    condition     = length(trim(var.subnet, " ")) > 0
    error_message = "subnet cannot be empty."
  }
}

#########################################
# Optional extras
#########################################

variable "labels" {
  description = "Labels sent as add_labels. Forces a new resource."
  type        = list(string)
  default     = null
}

variable "enable_tde" {
  description = "Whether transparent data encryption is enabled. Defaults to false. Forces a new resource."
  type        = bool
  default     = false
}

variable "advanced_settings_enabled" {
  description = "Whether advanced settings are enabled. Defaults to false. Maintenance windows are not set. Forces a new resource."
  type        = bool
  default     = false
}

variable "security_group" {
  description = "Allowed client CIDRs. Omit to leave security_group unset. Forces a new resource."

  type = object({
    allowed_ips = list(string)
  })

  default = null

  validation {
    condition     = var.security_group == null || length(var.security_group.allowed_ips) > 0
    error_message = "security_group.allowed_ips must contain at least one CIDR."
  }

  validation {
    condition = (
      var.security_group == null ||
      alltrue([
        for ip in var.security_group.allowed_ips : length(trim(ip, " ")) > 0
      ])
    )
    error_message = "security_group.allowed_ips cannot contain empty values."
  }
}

variable "backup" {
  description = "Backup protection plan. Omit to disable backup. Forces a new resource."

  type = object({
    protection_plan = string
  })

  default = null

  validation {
    condition     = var.backup == null || length(trim(var.backup.protection_plan, " ")) > 0
    error_message = "backup.protection_plan cannot be empty."
  }
}

variable "timeouts" {
  description = "Create and delete timeouts for the MSSQL instance."

  type = object({
    create = optional(string)
    delete = optional(string)
  })

  default = null
}
