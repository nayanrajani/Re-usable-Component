## Overview

This Re-usable component stores the Terraform and API helpers for the AFT global customizations. Global
customizations apply to **all** accounts deployed by AFT. This allows us to automatically enforce
security standards or provision standardized resources and infrastructure in every new account,
making compliance with our organization's standards a lot easier.

The resources can be created through Terraform or Python, leveraging the API helpers. The
customization run is parameterized at runtime.

## Global customizations currently being applied

- Configure AWS backup

## Modules created/used

- [AWS Backup](terraform/modules/aws-backup)

## Change validation

To check for the changes that would be applied (as part of terraform apply), one can run `terraform plan` . Steps to do so would be

1. Obtain access to AFT management account and any target account (for which global-customization repo is applicable) via AWS SSO. Follow [steps to configure and obtain credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html) for more details
2. Paste the contents of SSM Parameter (stored in AFT management account)
3. Switch to terraform directory of the repository
4. Run `terraform init`
5. Run `terraform plan` which will show the list of changes
   > **_NOTE:_** DO NOT run terraform apply as this will deploy the changes from local system

## Repo Segregation

- Put modules folder, templates folder and setup-aws-backup.tf file in Global customization repo.
- From account-request.tf file just pick custom fields and paste it under your account-request file in aft-account-request repo.
