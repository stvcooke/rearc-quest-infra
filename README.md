# rearc-quest-infra

This repository is to aid in the deployment of terraform files in stvcooke/rearc-quest.

It sets up a remote state through cloudformation, then sets up an two step pipeline for infrastructure deployment.
1. The first step is in github actions which essentially does a terraform plan and deposits the plan file into s3
1. The second step is an step function that takes the plan file in s3 and executes a terraform apply using it.

### Notes
* I have commented out the `DeletionPolicy: Retain` because I do not want to retain this state file after I am done with this.
* I am forgoing a deletion step to tear down the infrastructure for the sake of time.
