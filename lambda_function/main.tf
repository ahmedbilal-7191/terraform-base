provider "aws" {
  region = "us-west-2"
}
resource "aws_lambda_function" "hello_lambda" {
  function_name = var.lambda_function_name
  filename = data.archive_file.lambda_zip.output_path
  role = aws_iam_role.lambda_exec.arn
  handler = "lambda_function.handler"
  runtime = "python3.12"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  code_signing_config_arn = null
  depends_on = [ aws_iam_role_policy_attachment.lambda_logs ]
}
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}
resource "aws_iam_role_policy_attachment" "lambda_logs" {
    role = aws_iam_role.lambda_exec.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "${path.module}/lambda_function.py" # Points directly to your single file
  output_path = "${path.module}/${var.zip_file_name}"
}
