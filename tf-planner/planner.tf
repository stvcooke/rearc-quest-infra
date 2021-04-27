module "drop_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = var.terraform_plan_drop_bucket
  acl    = "private"

  attach_deny_insecure_transport_policy = true

  versioning = {
    enabled = true
  }

  tags = var.tags

}

module "github_actions_user" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-user"
  version = "~> 3.0"

  name          = var.github_actions_user
  force_destroy = true

  password_reset_required       = false
  create_iam_user_login_profile = false
  password_length               = 64

  pgp_key = var.planner_user_gpg_key

  tags = var.tags
}

module "github_actions_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 3.0"

  name        = "TerraformPlanDropAccess"
  path        = "/"
  description = "Grants access to s3 bucket for terraform remote state, dynamodb table for state locking, and s3 bucket for dropping the plan into."

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${aws_s3_bucket.remote_state_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${aws_s3_bucket.remote_state_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": "s3:ListBucket",
      "Resource": "${module.drop_bucket.arn}"
    },
    {
      "Effect": "Allow",
      "Action": ["s3:GetObject", "s3:PutObject"],
      "Resource": "${module.drop_bucket.arn}/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:DeleteItem"
      ],
      "Resource": "${aws_dynamodb_table.remote_state_locking_table.arn}"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "github_actions_user_policy_attachment" {
  user       = module.github_actions_user.this_iam_user_name
  policy_arn = module.github_actions_policy.arn
}
