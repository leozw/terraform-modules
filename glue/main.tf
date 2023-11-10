resource "aws_glue_catalog_database" "example" {
  name = var.glue_database_name
}

resource "aws_glue_catalog_table" "example" {
  name          = var.glue_table_name
  database_name = aws_glue_catalog_database.example.name
  table_type    = "EXTERNAL_TABLE"


}