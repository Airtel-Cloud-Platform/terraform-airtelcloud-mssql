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

# Network access by VPC and subnet. The subnet CIDR is allowed to connect.
module "mssql" {
  source = "../../"

  name              = "app-db"
  database_edition  = "web"
  collation         = "SQL_Latin1_General_CP1_CI_AS"
  features          = ["SQLENGINE"]
  compute_size      = "db.mssqlweb.uhper.cci.xlarge"
  storage_size      = 200
  availability_zone = "S1"
  db_name           = "AppDb"
  mssql_username    = "DbAdmin"
  password          = var.mssql_password

  vpc    = "copper-vpc1"
  subnet = "vlan-dbaas-91"
}
