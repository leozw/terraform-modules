## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_glue_catalog_database.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_database) | resource |
| [aws_glue_catalog_table.example](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/glue_catalog_table) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_glue_database_name"></a> [glue\_database\_name](#input\_glue\_database\_name) | Glue database name | `string` | `"example_database"` | no |
| <a name="input_glue_table_name"></a> [glue\_table\_name](#input\_glue\_table\_name) | Glue table name | `string` | `"example_table"` | no |

## Outputs

No outputs.
