terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "${var.remote_state_cfn_name}-tf-state"
    key = "${path.module}/prod/pipeline"
    dynamodb_table = "${var.remote_state_cfn_name}-tf-state-locking"
    region = var.aws_region
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
