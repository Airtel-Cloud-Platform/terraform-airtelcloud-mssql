# Airtel Cloud MSSQL Terraform Module

Terraform module for provisioning an Airtel Cloud MSSQL instance using `airtelcloud_mssql`.

Create, read, import, and delete are supported. Changing configuration forces a new instance. The API does not return the admin password.

## Network access

Set one of the following. At least one is required.

- `custom_cidr`: CIDR blocks allowed to connect. Use this instead of `vpc` and `subnet`.
- `vpc` and `subnet`, set together: the subnet CIDR is resolved by the provider and allowed to connect.
- Both: the subnet CIDR and the custom CIDRs are all allowed.

The VPC and subnet names are not sent on create; only the resolved CIDR is.

## Features

- Creates an MSSQL instance
- Resolves edition, collation, flavor, storage, and protection plan through the provider
- Network access by `custom_cidr`, by `vpc` and `subnet`, or both
- Optional backup protection plan
- Optional labels and transparent data encryption
- Create and delete timeouts (provider default is 30 minutes each)

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.5 |
| airtelcloud | >= 1.2.9, with `airtelcloud_mssql` and `custom_cidr` |

The 30-minute default timeouts and the delete fix (the API reports status `Deleted` instead of 404) need a provider release that includes them. With an older provider, set `timeouts` explicitly and expect destroy to wait for the full delete timeout.

## Usage

### Custom CIDR only

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
  db_name           = "AppDb"
  mssql_username    = "DbAdmin"
  password          = var.mssql_password

  custom_cidr = ["192.168.1.0/24"]
}
```

### VPC and subnet

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
  db_name           = "AppDb"
  mssql_username    = "DbAdmin"
  password          = var.mssql_password

  vpc    = "copper-vpc1"
  subnet = "vlan-dbaas-91"
}
```

### Complete

```hcl
module "mssql" {
  source = "Airtel-Cloud-Platform/mssql/airtelcloud"

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

  vpc         = "copper-vpc1"
  subnet      = "vlan-dbaas-91"
  custom_cidr = ["192.168.1.0/24"]

  backup = {
    protection_plan = "CH26_AZ1_PaaS_MSSQLIP_DAILY_FULL_2100_PP"
  }

  timeouts = {
    create = "45m"
    delete = "45m"
  }
}
```

Runnable versions are in `examples/basic` (custom CIDR only), `examples/vpc-subnet`, and `examples/complete`.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| name | Instance name. Lowercase letters, digits, and hyphens, at most 14 characters | string | n/a | Yes |
| database_edition | Edition such as `web`, `standard`, or `enterprise` | string | n/a | Yes |
| collation | Collation for the edition | string | n/a | Yes |
| features | Feature values such as `SQLENGINE` | list(string) | n/a | Yes |
| compute_size | Flavor name for the edition | string | n/a | Yes |
| storage_size | Size in GiB, 200 to 2048 in steps of 10 from 200 | number | n/a | Yes |
| availability_zone | Availability zone code such as `S1` | string | n/a | Yes |
| db_name | Initial database name | string | n/a | Yes |
| mssql_username | Admin username | string | n/a | Yes |
| password | Admin password. Sensitive | string | n/a | Yes |
| vpc | VPC name used to resolve `subnet`. Set together with `subnet` | string | `null` | See Network access |
| subnet | Subnet name within `vpc`. Set together with `vpc` | string | `null` | See Network access |
| custom_cidr | CIDR blocks allowed to connect. Use instead of `vpc` and `subnet`, or with them | list(string) | `null` | See Network access |
| description | Instance description | string | `"Managed by Terraform"` | No |
| storage_type | Volume type label | string | `"High Performance"` | No |
| labels | Labels sent as `add_labels` | list(string) | `null` | No |
| enable_tde | Transparent data encryption | bool | `false` | No |
| advanced_settings_enabled | Advanced settings flag | bool | `false` | No |
| backup | Protection plan name from the netbackup catalog. Omit to disable backup | object | `null` | No |
| timeouts | `create` and `delete` timeouts, such as `"45m"`. Provider default is 30 minutes each | object | `null` | No |
| security_group | Deprecated: use `custom_cidr`. `allowed_ips` is merged into `custom_cidr` | object | `null` | No |

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
| connection_string | Connection string. Sensitive |
| vpc | VPC name from the configuration. Null when only `custom_cidr` is used, and after import |
| subnet | Subnet name from the configuration. Null when only `custom_cidr` is used, and after import |
| custom_cidr | Custom CIDR blocks from the configuration. Null when none are set |
| mssql | Selected instance attributes |

## Notes

- Configuration changes force a new instance.
- `name` can have at most 14 characters. The API rejects longer names, and the module checks this during plan.
- Create waits until status is `Active`. `Requested`, `Initiated`, and `Resizing` are still in progress. `Failed` fails the apply. Create typically takes about 14 minutes.
- Delete waits until the API reports status `Deleted` or GET returns 404. It typically takes 2 to 3 minutes.
- `vpc` and `subnet` must be set together. At least one of `custom_cidr` or `vpc` with `subnet` is required; the module checks this during plan.
- `custom_cidr` values must be valid CIDR blocks.
- `security_group` is deprecated. Its `allowed_ips` are merged into `custom_cidr`, so existing callers keep working. Move to `custom_cidr`.
- Omit `backup` to disable backup. When set, `protection_plan` must be a name from the netbackup catalog.
- Import is by instance UUID. Import cannot populate `password`, `vpc`, `subnet`, or `custom_cidr` because the API does not return them, so a following plan will want to set them.
