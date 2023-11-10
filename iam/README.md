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
| [aws_iam_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy_attachment) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assume_role_policy"></a> [assume\_role\_policy](#input\_assume\_role\_policy) | Policy that grants an entity permission to assume the role. | `string` | `null` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Create policy | `bool` | `false` | no |
| <a name="input_create_role"></a> [create\_role](#input\_create\_role) | Create role | `bool` | `false` | no |
| <a name="input_groups"></a> [groups](#input\_groups) | The group(s) the policy should be applied to | `list` | `[]` | no |
| <a name="input_name_iam_attach"></a> [name\_iam\_attach](#input\_name\_iam\_attach) | The name of the attachment. This cannot be an empty string. | `any` | `null` | no |
| <a name="input_policy"></a> [policy](#input\_policy) | The inline policy document. This is a JSON formatted string. | `string` | `null` | no |
| <a name="input_policy_iam"></a> [policy\_iam](#input\_policy\_iam) | This is a JSON formatted string. | `any` | `null` | no |
| <a name="input_policy_name_iam"></a> [policy\_name\_iam](#input\_policy\_name\_iam) | The name of the policy. If omitted, Terraform will assign a random, unique name. | `any` | `null` | no |
| <a name="input_policyname"></a> [policyname](#input\_policyname) | Name to be used the resources as identifier | `string` | `null` | no |
| <a name="input_rolename"></a> [rolename](#input\_rolename) | Name to be used the resources as identifier | `string` | `null` | no |
| <a name="input_roles_policy"></a> [roles\_policy](#input\_roles\_policy) | The role(s) the policy should be applied to | `list` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |
| <a name="input_users_policy"></a> [users\_policy](#input\_users\_policy) | The user(s) the policy should be applied to | `list` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | Output role arn |
| <a name="output_name"></a> [name](#output\_name) | Output role name |
