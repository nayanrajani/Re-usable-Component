locals {
    # vpc cidr for sg_comsrv_endpoint, which want to use vpc endpoints for session manager
  # Security Group Settings
  inbound_ports = [443]
  rules = [{
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-Name"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-Name"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-Name"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-Name"]],
    }, {
    cidr_blocks = [module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}account-Name"]],
    }
  ]
}