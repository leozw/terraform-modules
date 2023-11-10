resource "aws_athena_workgroup" "example" {
  name = var.athena_workgroup_name
}


resource "aws_athena_named_query" "example" {
  name      = "example-query"
  database  = aws_glue_catalog_database.example.name
  query     = "SELECT * FROM example_table"
  workgroup = aws_athena_workgroup.example.name
}


output "rds_endpoint" {
  value = aws_db_instance.example.endpoint
}