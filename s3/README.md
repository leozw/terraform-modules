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
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_lifecycle_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_ownership_controls.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.allow_access_from_another_account](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_s3_object.object](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |
| [aws_canonical_user_id.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/canonical_user_id) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_abort_incomplete_multipart_upload"></a> [abort\_incomplete\_multipart\_upload](#input\_abort\_incomplete\_multipart\_upload) | Number of days after which Amazon S3 aborts an incomplete multipart upload | `map(any)` | `{}` | no |
| <a name="input_block_public_acls"></a> [block\_public\_acls](#input\_block\_public\_acls) | Whether Amazon S3 should block public ACLs for this bucket. Defaults to false | `bool` | `false` | no |
| <a name="input_block_public_policy"></a> [block\_public\_policy](#input\_block\_public\_policy) | Whether Amazon S3 should block public bucket policies for this bucket. Defaults to false | `bool` | `false` | no |
| <a name="input_create_bucket_ownership_controls"></a> [create\_bucket\_ownership\_controls](#input\_create\_bucket\_ownership\_controls) | Create bucket\_ownership\_controls | `bool` | `false` | no |
| <a name="input_create_bucket_versioning"></a> [create\_bucket\_versioning](#input\_create\_bucket\_versioning) | Create Versioning | `bool` | `false` | no |
| <a name="input_create_lifecycle"></a> [create\_lifecycle](#input\_create\_lifecycle) | Create lifecycle | `bool` | `false` | no |
| <a name="input_create_object"></a> [create\_object](#input\_create\_object) | Create object in bucket | `bool` | `false` | no |
| <a name="input_create_policy"></a> [create\_policy](#input\_create\_policy) | Enable used policy bucket | `bool` | `false` | no |
| <a name="input_create_website_configuration"></a> [create\_website\_configuration](#input\_create\_website\_configuration) | Create website\_configuration | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Env tags | `string` | `null` | no |
| <a name="input_expiration"></a> [expiration](#input\_expiration) | Configuration block that specifies the expiration for the lifecycle of the object in the form of date, days and, whether the object has a delete marker | `map(any)` | `{}` | no |
| <a name="input_filter"></a> [filter](#input\_filter) | Configuration block used to identify objects that a Lifecycle Rule applies to. | `map(any)` | `{}` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Boolean that indicates all objects (including any locked objects) should be deleted from the bucket when the bucket is destroyed so that the bucket can be destroyed without error | `bool` | `false` | no |
| <a name="input_grant"></a> [grant](#input\_grant) | An ACL policy grant. Conflicts with `acl` | `any` | `[]` | no |
| <a name="input_ignore_public_acls"></a> [ignore\_public\_acls](#input\_ignore\_public\_acls) | Whether Amazon S3 should ignore public ACLs for this bucket. Defaults to false | `bool` | `false` | no |
| <a name="input_key_error"></a> [key\_error](#input\_key\_error) | Object key name to use when a 4XX class error occurs | `string` | `"error.html"` | no |
| <a name="input_key_object"></a> [key\_object](#input\_key\_object) | Name of the object once it is in the bucket. | `any` | `null` | no |
| <a name="input_name_bucket"></a> [name\_bucket](#input\_name\_bucket) | Name to be used the resources as identifier | `string` | n/a | yes |
| <a name="input_noncurrent_version_expiration"></a> [noncurrent\_version\_expiration](#input\_noncurrent\_version\_expiration) | Number of days an object is noncurrent before Amazon S3 can perform the associated action. Must be a positive integer. | `map(any)` | `{}` | no |
| <a name="input_policy_bucket"></a> [policy\_bucket](#input\_policy\_bucket) | Text of the policy. Although this is a bucket policy rather than an IAM policy, the aws\_iam\_policy\_document data source may be used, so long as it specifies a principal | `string` | `""` | no |
| <a name="input_restrict_public_buckets"></a> [restrict\_public\_buckets](#input\_restrict\_public\_buckets) | Whether Amazon S3 should restrict public bucket policies for this bucket. Defaults to false | `bool` | `false` | no |
| <a name="input_rule_id"></a> [rule\_id](#input\_rule\_id) | Unique identifier for the rule. The value cannot be longer than 255 characters | `string` | `""` | no |
| <a name="input_source_object"></a> [source\_object](#input\_source\_object) | Conflicts with source and content\_base64) Literal string value to use as the object content, which will be uploaded as UTF-8-encoded text. | `any` | `null` | no |
| <a name="input_status_lifecycle"></a> [status\_lifecycle](#input\_status\_lifecycle) | Whether the rule is currently being applied. Valid values: Enabled or Disabled | `string` | `"Disabled"` | no |
| <a name="input_status_version"></a> [status\_version](#input\_status\_version) | Versioning state of the bucket. Valid values: Enabled, Suspended, or Disabled. | `string` | `"Enabled"` | no |
| <a name="input_suffix"></a> [suffix](#input\_suffix) | Suffix that is appended to a request that is for a directory on the website endpoint. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket-arn"></a> [bucket-arn](#output\_bucket-arn) | The arn bucket |
| <a name="output_bucket-id"></a> [bucket-id](#output\_bucket-id) | The id bucket |
| <a name="output_bucket-name"></a> [bucket-name](#output\_bucket-name) | The name bucket |
| <a name="output_bucket-object-id"></a> [bucket-object-id](#output\_bucket-object-id) | The id object |
