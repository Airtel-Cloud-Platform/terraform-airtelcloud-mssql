# Complete MSSQL Example

This example provisions an MSSQL instance using backup, labels, and timeouts.

## What This Example Shows

- Backup protection plan
- Labels and encryption flags
- Security group CIDR allow list
- Resource timeouts

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
- `vpc` and `subnet` are stored in state and are not sent to the API.
