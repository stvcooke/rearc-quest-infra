module "lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = "rearc-quest-terraform-apply"
  description   = "Terraform apply function"
  handler       = "service.handler"
  runtime       = "python3.8"
  timeout       = 300

  create_role = false
  lambda_role = aws_iam_role.executor_role.arn

  source_path = "../src/service.py"

  tags = var.tags
}

resource "aws_iam_role" "executor_role" {
  name                = "rearc-quest-terraform-apply-role"
  assume_role_policy  = data.aws_iam_policy_document.executor_assume_policy.json
  managed_policy_arns = [data.aws_iam_policy.admin_policy.arn]
}

data "aws_iam_policy_document" "executor_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda_function.lambda_function_arn
  principal     = "s3.amazonaws.com"
  source_arn    = data.aws_s3_bucket.drop_bucket.arn
}

resource "aws_s3_bucket_notification" "drop_bucket_notification" {
  bucket = data.aws_s3_bucket.drop_bucket.id

  lambda_function {
    id                  = "rearc-quest-drop-notification"
    lambda_function_arn = module.lambda_function.lambda_function_arn
    events              = ["s3:ObjectCreated:*"]
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}
