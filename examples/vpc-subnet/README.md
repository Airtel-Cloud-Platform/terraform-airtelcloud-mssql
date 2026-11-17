# VPC and Subnet MSSQL Example

This example provisions an MSSQL instance and allows access from a subnet by VPC and subnet name.

## What This Example Shows

- Network access with `vpc` and `subnet` and no `custom_cidr`
- The subnet CIDR is resolved by the provider and sent as an allowed IP

## Files

- `main.tf`: provider config and module call
- `variables.tf`: provider credentials and instance password

## How To Run

1. Go to this folder:

```bash
cd examples/vpc-subnet
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

- `vpc` and `subnet` must be set together. To allow other networks, add `custom_cidr`.
- The VPC and subnet names are not sent on create; only the subnet CIDR is.
- Create typically takes about 14 minutes.
