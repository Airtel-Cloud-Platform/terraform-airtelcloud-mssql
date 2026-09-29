terraform {
  required_providers {
    airtelcloud = {
      source  = "Airtel-Cloud-Platform/airtelcloud"
      # version = ">= 1.2.6"
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

  name              = "app-db"
  database_edition  = "web"
  collation         = "SQL_Latin1_General_CP1_CI_AS"
  features          = ["SQLENGINE"]
  compute_size      = "db.mssqlweb.uhper.cci.xlarge"
  storage_size      = 200
  availability_zone = "S1"
  vpc               = "copper-vpc1"
  subnet            = "vlan-dbaas-91"
  db_name           = "AppDb"
  mssql_username    = "DbAdmin"
  password          = var.mssql_password

  security_group = {
    allowed_ips = ["192.168.1.0/24"]
  }
}
