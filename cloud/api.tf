locals {
  function_prefix = "${var.app_prefix}-${local.env}"
  functions = {
    "hello-world" = {
      timeout     = 30
      memory_size = 128
      description = "App to say hello world"
    }
  }
}

# Create lambda execution role
resource "aws_iam_role" "lambda_role" {
  name = "${var.app_prefix}-lambda-role-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })

  # Allow lambda to log to cloudwatch
  inline_policy {
    name = "lambda-cloudwatch-logs"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }]
    })
  }
}

# Create lambda functions
resource "aws_lambda_function" "api" {
  for_each = local.functions

  filename         = "../functions/dist/${each.key}.zip"
  function_name    = "${local.function_prefix}-${each.key}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "${each.key}.execute"
  source_code_hash = filebase64sha256("../functions/dist/${each.key}.zip")
  runtime          = "nodejs20.x"
  timeout          = lookup(each.value, "timeout", 30)
  memory_size      = lookup(each.value, "memory_size", 128)
  publish          = true
  description      = lookup(each.value, "description", "")
  architectures    = ["arm64"]

  environment {
    variables = merge({
      NODE_OPTIONS = "--enable-source-maps"
      APP_ENV      = local.env
    }, lookup(each.value, "env", {}))
  }
}

# Create a lambda function url
resource "aws_lambda_function_url" "api" {
  for_each = aws_lambda_function.api

  function_name      = each.value.function_name
  authorization_type = "NONE"
}

# Output the lambda function urls
output "api_urls" {
  value = {
    for k, v in aws_lambda_function_url.api : k => v.function_url
  }
}

# Create cloudwatch log groups
resource "aws_cloudwatch_log_group" "api" {
  for_each = aws_lambda_function.api

  name              = "/aws/lambda/${each.value.function_name}"
  retention_in_days = 14
}
