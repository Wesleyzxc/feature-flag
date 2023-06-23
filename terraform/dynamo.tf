resource "aws_dynamodb_table" "features_table" {
  name           = "WesTest"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  range_key      = "Target"
  hash_key       = "Feature"
  

  attribute {
    name = "Target"
    type = "S"
  }
  attribute {
    name = "Feature"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-features-table"
    Environment = "production"
  }
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.features_table.name
}

output "dynamodb_table_arn" {
  value = aws_dynamodb_table.features_table.arn
}
