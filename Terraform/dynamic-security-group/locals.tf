locals {
    # vpc cidr for sg_comsrv_endpoint, which want to use vpc endpoints for session manager
  # Security Group Settings
  inbound_ports = [443]
  rules = [{
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-lz2.0-shared-dev/vpc_cidr"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-lz2.0-shared-prod/vpc_cidr"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-lz2.0-shared-uat/vpc_cidr"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-lz2.0-network/vpc_cidr"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-lz2.0-central-egress/vpc_cidr"]],
    }
  ]
}