# Basic MSSQL Example

This example provisions an MSSQL instance using the module from the repository root.

## What This Example Shows

- Single instance creation
- Required edition, collation, flavor, storage, zone, VPC, and subnet
- Security group CIDR allow list
- Minimal optional inputs

## Files

- `main.tf`: provider config and module call
- `variables.tf`: input variables used by the provider block
- `terraform.tfvars.example`: sample variable names for local testing

## How To Run

1. Go to this folder:

```bash
cd examples/basic
```

2. Initialize Terraform:

```bash
terraform init
```

3. Copy `terraform.tfvars.example` to `terraform.tfvars` and set your own credentials. Do not commit secrets.

4. If you want to test against a locally built provider binary, copy `terraform.rc.example` to `terraform.rc`, point the `dev_overrides` path at your build output, and set `TF_CLI_CONFIG_FILE=./terraform.rc` before running Terraform.

5. Reinitialize Terraform so it picks up the override:

```bash
terraform init -reconfigure
```

6. Plan:

```bash
terraform plan
```

7. Apply:

```bash
terraform apply
```

8. Destroy when done:

```bash
terraform destroy
```

## Notes

- Use your own Airtel Cloud API credentials.
- The provider build must include `airtelcloud_mssql`.
- Keep credentials and the database password out of version control.
- If your environment uses a different region or API endpoint, update the provider inputs.
- `dev_overrides` is only for local provider testing; remove the CLI config when you want Terraform to use the published provider.
