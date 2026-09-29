# Airtel Cloud MSSQL Terraform Module

Terraform module for provisioning an Airtel Cloud MSSQL instance using `airtelcloud_mssql`.

Create, read, import, and delete are supported. Changing configuration forces a new instance. The API does not return the admin password. `vpc` and `subnet` are stored in state for later use and are not sent on create.

The installed provider must include the `airtelcloud_mssql` resource.

## Features

- Creates an MSSQL instance
- Resolves edition, collation, flavor, storage, and protection plan through the provider
- Optional backup protection plan
- Optional security group CIDR allow list
- Optional labels and transparent data encryption
- Create and delete timeouts

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5 |
| airtelcloud | >= 1.2.6, with `airtelcloud_mssql` |

## Usage

### Basic Example

```hcl
module "mssql" {
  source = "Airtel-Cloud-Platform/mssql/airtelcloud"

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
```

### Complete Example

```hcl
module "mssql" {
  source = "Airtel-Cloud-Platform/mssql/airtelcloud"

  name                       = "app-db"
  description                = "Application MSSQL instance"
  database_edition           = "web"
  collation                  = "SQL_Latin1_General_CP1_CI_AS"
  features                   = ["SQLENGINE"]
  compute_size               = "db.mssqlweb.uhper.cci.xlarge"
  storage_size               = 200
  storage_type               = "High Performance"
  availability_zone          = "S1"
  vpc                        = "copper-vpc1"
  subnet                     = "vlan-dbaas-91"
  db_name                    = "AppDb"
  mssql_username             = "DbAdmin"
  password                   = var.mssql_password
  labels                     = ["terraform"]
  enable_tde                 = false
  advanced_settings_enabled  = false

  backup = {
    protection_plan = "CH26_AZ1_PaaS_MSSQLIP_DAILY_FULL_2100_PP"
  }

  security_group = {
    allowed_ips = ["192.168.1.0/24"]
  }

  timeouts = {
    create = "15m"
    delete = "15m"
  }
}
```

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| name | Instance name | string | Yes |
| database_edition | Edition such as `web` | string | Yes |
| collation | Collation for the edition | string | Yes |
| features | Feature values such as `SQLENGINE` | list(string) | Yes |
| compute_size | Flavor name | string | Yes |
| storage_size | Size in GiB, 200–2048 in steps of 10 from 200 | number | Yes |
| availability_zone | Availability zone code | string | Yes |
| vpc | VPC name, stored only | string | Yes |
| subnet | Subnet name, stored only | string | Yes |
| db_name | Initial database name | string | Yes |
| mssql_username | Admin username | string | Yes |
| password | Admin password | string | Yes |
| description | Instance description | string | No |
| storage_type | Volume type label (default `High Performance`) | string | No |
| labels | Labels sent as `add_labels` | list(string) | No |
| enable_tde | Transparent data encryption | bool | No |
| advanced_settings_enabled | Advanced settings flag | bool | No |
| security_group | Allowed client CIDRs (`allowed_ips`) | object | No |
| backup | Protection plan name | object | No |
| timeouts | Create and delete timeouts | object | No |

## Outputs

| Name | Description |
|------|-------------|
| id | Instance UUID |
| name | Configured instance name |
| version | Version resolved from the edition |
| db_name | Initial database name |
| mssql_username | Admin username |
| status | Current instance status |
| availability_zone | Availability zone |
| port | Database port |
| created_at | Creation timestamp |
| connection_string | Connection string |
| vpc | Stored VPC name |
| subnet | Stored subnet name |
| mssql | Selected instance attributes |

## Notes

- Configuration changes force a new instance.
- Create waits until status is `Active`. `Requested`, `Initiated`, and `Resizing` are still in progress. `Failed` fails the apply.
- Delete waits until GET returns 404.
- Omit `backup` to disable backup. When set, `protection_plan` must be a name from the netbackup catalog.
- `vpc` and `subnet` are not sent to the API.
- Import cannot populate `password`, `vpc`, or `subnet` because the API does not return them.
