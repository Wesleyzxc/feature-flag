resource "aws_lambda_function" "feature_lambda" {
  function_name = "westest"
  role          = aws_iam_role.lambda_dynamo_role.arn
  handler       = "app.lambda_handler"

  filename         = "app.zip"
  source_code_hash = data.archive_file.python_lambda_package.output_base64sha256
  runtime          = "python3.10"

  ephemeral_storage {
    size = 512
  }

  tracing_config {
    mode = "PassThrough"
  }
}

data "archive_file" "python_lambda_package" {
  type        = "zip"
  source_file = "${path.root}/handler/app.py"
  output_path = "app.zip"
}


# role for dynamodb executor
resource "aws_iam_role" "lambda_dynamo_role" {
  name = "lambda_dynamodb_role"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}