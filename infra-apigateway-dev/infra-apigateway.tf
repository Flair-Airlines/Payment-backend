provider "aws" {
  region = "ca-central-1"
}

# Reuse Existing Lambda Authorizer
data "aws_lambda_function" "existing_lambda_authorizer" {
  function_name = "existing-lambda-authorizer"  # Replace with actual function name
}

# Create REST API Gateway
resource "aws_api_gateway_rest_api" "rule_backend_api" {
  name        = "rule-backend-api"
  description = "API Gateway for Rule Backend Project"
}

# Create API Gateway Resources (Endpoints)
resource "aws_api_gateway_resource" "rules_resource" {
  rest_api_id = aws_api_gateway_rest_api.rule_backend_api.id
  parent_id   = aws_api_gateway_rest_api.rule_backend_api.root_resource_id
  path_part   = "rules"
}

resource "aws_api_gateway_resource" "rule_id_resource" {
  rest_api_id = aws_api_gateway_rest_api.rule_backend_api.id
  parent_id   = aws_api_gateway_resource.rules_resource.id
  path_part   = "{id}"
}

# POST /rules Method
resource "aws_api_gateway_method" "post_rules_method" {
  rest_api_id   = aws_api_gateway_rest_api.rule_backend_api.id
  resource_id   = aws_api_gateway_resource.rules_resource.id
  http_method   = "POST"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

# GET /rules/{id} Method
resource "aws_api_gateway_method" "get_rule_by_id_method" {
  rest_api_id   = aws_api_gateway_rest_api.rule_backend_api.id
  resource_id   = aws_api_gateway_resource.rule_id_resource.id
  http_method   = "GET"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

# DELETE /rules/{id} Method
resource "aws_api_gateway_method" "delete_rule_by_id_method" {
  rest_api_id   = aws_api_gateway_rest_api.rule_backend_api.id
  resource_id   = aws_api_gateway_resource.rule_id_resource.id
  http_method   = "DELETE"
  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

# Create Lambda Authorizer
resource "aws_api_gateway_authorizer" "lambda_authorizer" {
  rest_api_id = aws_api_gateway_rest_api.rule_backend_api.id
  name        = "existing_lambda_authorizer"
  type        = "TOKEN"
  authorizer_uri = data.aws_lambda_function.existing_lambda_authorizer.invoke_arn
}

# Integrate with Backend Lambda Functions (for rule operations)
resource "aws_api_gateway_integration" "post_rules_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rule_backend_api.id
  resource_id             = aws_api_gateway_resource.rules_resource.id
  http_method             = aws_api_gateway_method.post_rules_method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend_rule_operations.invoke_arn
}

resource "aws_api_gateway_integration" "get_rule_by_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rule_backend_api.id
  resource_id             = aws_api_gateway_resource.rule_id_resource.id
  http_method             = aws_api_gateway_method.get_rule_by_id_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend_rule_operations.invoke_arn
}

resource "aws_api_gateway_integration" "delete_rule_by_id_integration" {
  rest_api_id             = aws_api_gateway_rest_api.rule_backend_api.id
  resource_id             = aws_api_gateway_resource.rule_id_resource.id
  http_method             = aws_api_gateway_method.delete_rule_by_id_method.http_method
  integration_http_method = "DELETE"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.backend_rule_operations.invoke_arn
}

# Deploy the API Gateway
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on = [
    aws_api_gateway_method.post_rules_method,
    aws_api_gateway_method.get_rule_by_id_method,
    aws_api_gateway_method.delete_rule_by_id_method,
    aws_api_gateway_integration.post_rules_integration,
    aws_api_gateway_integration.get_rule_by_id_integration,
    aws_api_gateway_integration.delete_rule_by_id_integration,
  ]
  rest_api_id = aws_api_gateway_rest_api.rule_backend_api.id
  stage_name  = "Dev"
}

# Create API Gateway Stage
resource "aws_api_gateway_stage" "Dev_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.rule_backend_api.id
  stage_name    = "Dev"

  cache_cluster_enabled = true
  cache_cluster_size    = "0.5"  # Adjust based on required capacity
}

# Create API Gateway Method Settings
resource "aws_api_gateway_method_settings" "method_settings" {
  rest_api_id = aws_api_gateway_rest_api.rule_backend_api.id
  stage_name  = aws_api_gateway_stage.Dev_stage.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
    throttling_burst_limit = 200
    throttling_rate_limit = 100
  }
}


# Lambda Function for Rule Operations (Backend)
resource "aws_lambda_function" "backend_rule_operations" {
  function_name = "backend-rule-operations"
  s3_bucket     = "my-lambda-functions"
  s3_key        = "rule-operations.zip"
  handler       = "index.handler"
  runtime       = "python3.11"
  role          = aws_iam_role.lambda_exec_role.arn
  environment {
    variables = {
      VPC_LINK_ID = "vpc-link-id"  # Replace with the actual VPC link ID if applicable
    }
  }
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action    = "sts:AssumeRole",
      Effect    = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# Attach the basic execution policy for Lambda
resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
