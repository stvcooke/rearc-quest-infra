variable "aws_region" {
  default = "us-east-2"
}

variable "remote_state_cfn_name" {
  type = string
  description = "The stack name used for the cfn template remote-state.yaml"
  default = "rearc-quest-infra"
}

variable "terraform_plan_drop_bucket" {
  type = string
  description = "The name of the bucket to store the terraform plan outputs to be executed by terraform apply."
  default = "rearc-quest-terraform-plan-drop"
}

variable "tags" {
  type = map

  default = {
    cost-center = "rearc-quest"
    owner = "scooke"
  }
}
