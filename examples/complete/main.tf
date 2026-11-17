terraform {
  required_providers {
    airtelcloud = {
      source  = "Airtel-Cloud-Platform/airtelcloud"
      version = ">= 1.2.9"
    }
  }
}

provider "airtelcloud" {
  api_endpoint = "https://south.cloud.airtel.in"
  api_key      = var.airtel_api_key
  api_secret   = var.airtel_api_secret
  region       = "south"
  organization = var.organization
  project_name = var.project_name
}

module "mssql" {
  source = "../../"

  name                      = "app-db"
  description               = "Application MSSQL instance"
  database_edition          = "web"
  collation                 = "SQL_Latin1_General_CP1_CI_AS"
  features                  = ["SQLENGINE"]
  compute_size              = "db.mssqlweb.uhper.cci.xlarge"
  storage_size              = 200
  storage_type              = "High Performance"
  availability_zone         = "S1"
  db_name                   = "AppDb"
  mssql_username            = "DbAdmin"
  password                  = var.mssql_password
  labels                    = ["terraform"]
  enable_tde                = false
  advanced_settings_enabled = false

  # Network access: the subnet CIDR plus extra custom CIDRs.
  vpc         = "copper-vpc1"
  subnet      = "vlan-dbaas-91"
  custom_cidr = ["192.168.1.0/24"]

  backup = {
    protection_plan = "CH26_AZ1_PaaS_MSSQLIP_DAILY_FULL_2100_PP"
  }

  # Provider default is 30 minutes each. Create typically takes about 14 minutes.
  timeouts = {
    create = "45m"
    delete = "45m"
  }
}
