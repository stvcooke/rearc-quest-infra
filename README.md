# rearc-quest-infra

This repository is to aid in the deployment of Terraform files in stvcooke/rearc-quest. It probably should be called "pipeline" instead of "infra", but that's okay for now.

It sets up a remote state through CloudFormation in `remote-state.yaml`, then sets up an two step pipeline for infrastructure deployment.
1. The first step is in github actions which essentially does a terraform plan and deposits the plan file into s3. The IAM and S3 resources are declared in `tf-planner/planner.tf` while the github actions are in the `.github/workflows/tf-plan.yaml` of the rearc-quest repository.
1. The second step is a lambda function off an s3 trigger that takes the plan file in s3 and executes a terraform apply using it. It's resources are declared in `tf-executor/executor.tf` and the python script for it is in `src/service.py`.

### Notes
* I have commented out the `DeletionPolicy: Retain` because I do not want to retain this state file after I am done with this quest.
* I am forgoing a deletion step to tear down the infrastructure for the sake of time.
