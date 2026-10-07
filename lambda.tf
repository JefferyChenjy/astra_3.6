
locals {
  function_name = "hello-world"
}

# Zip app.py so Lambda can use it
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/app.py"
  output_path = "${path.module}/lambda.zip"
}

# Role the Lambda runs as
resource "aws_iam_role" "lambda_role" {
  name = "${local.function_name}-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

# Lets the Lambda write logs to CloudWatch
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lets the Lambda send traces to X-Ray
resource "aws_iam_role_policy_attachment" "lambda_xray" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXRayDaemonWriteAccess"
}

# Log group with retention, so logs don't pile up forever
resource "aws_cloudwatch_log_group" "lambda_logs" {
  name              = "/aws/lambda/${local.function_name}"
  retention_in_days = 14
}

resource "aws_lambda_function" "hello_world" {
  function_name    = local.function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "app.lambda_test"
  runtime          = "python3.12"
  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  timeout          = 10

  tracing_config {
    mode = "Active"
  }

  depends_on = [
    aws_iam_role_policy_attachment.lambda_logs,
    aws_cloudwatch_log_group.lambda_logs,
  ]
}

output "lambda_function_name" {
  value = aws_lambda_function.hello_world.function_name
}