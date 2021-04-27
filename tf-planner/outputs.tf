output "planner_user_access_key" {
  value = module.github_actions_user.this_iam_access_key_id
}

output "planner_user_encrypted_secret_key" {
  value = module.github_actions_user.this_iam_access_key_encrypted_secret
}

output "drop_bucket" {
  value = module.drop_bucket.s3_bucket_id
}
