# Complete MSSQL Example

This example provisions an MSSQL instance using backup, labels, and timeouts.

## What This Example Shows

- Backup protection plan
- Labels and encryption flags
- Network access with `vpc`, `subnet`, and `custom_cidr` together
- Resource timeouts (provider default is 30 minutes; create typically takes about 14)

## Files

- `main.tf`: complete provider and module configuration
- `variables.tf`: provider credentials and instance password

## How To Run

1. Go to this folder:

```bash
cd examples/complete
```

2. Initialize Terraform:

```bash
terraform init
```

3. Set required provider variables (API key, API secret, organization, project, and password). Do not commit secrets.

4. Plan:

```bash
terraform plan
```

5. Apply:

```bash
terraform apply
```

6. Destroy when done:

```bash
terraform destroy
```

## Notes

- `protection_plan` must match a name from the netbackup catalog.
- Adjust flavor, zone, CIDRs, edition, and collation to match your environment.
- Configuration changes force a new instance.
- `vpc` and `subnet` must be set together. Their names are not sent on create; the subnet CIDR is sent as an allowed IP, along with any `custom_cidr`.
- Remove `vpc`, `subnet`, or `custom_cidr` if you only need one network option.
