terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "rearc-quest-infra-tf-state"
    key = "rearc-quest-infra/prod/tf-executor"
    dynamodb_table = "rearc-quest-infra-tf-state-locking"
    region = "us-east-2"
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_s3_bucket" "remote_state_bucket" {
  bucket = "${var.remote_state_cfn_name}-tf-state"
}

data "aws_dynamodb_table" "remote_state_locking_table" {
  name = "${var.remote_state_cfn_name}-tf-state-locking"
}

data "aws_iam_policy" "admin_policy" {
  arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

data "aws_s3_bucket" "drop_bucket" {
  vucket = var.terraform_plan_drop_bucket
}
