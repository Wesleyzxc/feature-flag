resource "aws_apigatewayv2_api" "feature_gateway" {
  name          = "westest"
  protocol_type = "HTTP"
}


resource "aws_apigatewayv2_stage" "lambda" {
  api_id = aws_apigatewayv2_api.feature_gateway.id

  name        = "serverless_lambda_stage"
  auto_deploy = true
}

resource "aws_apigatewayv2_integration" "feature_integration" {
  api_id = aws_apigatewayv2_api.feature_gateway.id

  integration_uri    = aws_lambda_function.feature_lambda.invoke_arn
  integration_type   = "AWS_PROXY"
  integration_method = "POST"
}

resource "aws_apigatewayv2_route" "feature_route" {
  api_id = aws_apigatewayv2_api.feature_gateway.id

  route_key = "ANY /feature-flag"
  target    = "integrations/${aws_apigatewayv2_integration.feature_integration.id}"
}