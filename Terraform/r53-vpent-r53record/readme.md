## Overview

This Re-usable component stores the Terraform and API helpers for the AFT global customizations. Global
customizations apply to **all** accounts deployed by AFT. This allows us to automatically enforce
security standards or provision standardized resources and infrastructure in every new account,
making compliance with our organization's standards a lot easier.

The resources can be created through Terraform or Python, leveraging the API helpers. The
customization run is parameterized at runtime.

## Account customizations currently being applied

- Configure Route53 private hosted zone
- Configure hosted zone authorization for all other accounts VPC.
- Configure VPCEndpoint for service you want to use.
- Configure A Record for each of the service.
- Configure in individual account to accept the authorization from a central account.

## Change validation

To check for the changes that would be applied (as part of terraform apply), one can run `terraform plan` . Steps to do so would be

1. Obtain access to AFT management account and any target account (for which global-customization repo is applicable) via AWS SSO. Follow [steps to configure and obtain credentials](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-sso.html) for more details
2. Paste the contents of SSM Parameter (stored in AFT management account)
3. Switch to terraform directory of the repository
4. Run `terraform init`
5. Run `terraform plan` which will show the list of changes
   > **_NOTE:_** DO NOT run terraform apply as this will deploy the changes from local system

## Repo Segregation

- do remember this cidr block are being fetched from ssm parameter.
- Put Acceptance code under your individual accounts to accept the private hosted zone.
- Put locals.tf and r53.tf file under central account from where you want to manage the endpoint services.
