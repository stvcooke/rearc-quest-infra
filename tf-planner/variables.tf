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

variable "github_actions_user" {
  type = string
  description = "The name of the user to be used by the github actions."
  default = "github-actions-runner"
}

variable "tags" {
  type = map

  default = {
    cost-center = "rearc-quest"
    owner = "scooke"
  }
}

variable "planner_user_gpg_key" {
  type = string
  default = <<EOF
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
EOF
}
