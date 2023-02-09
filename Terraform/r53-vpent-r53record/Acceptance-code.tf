module "vpc_endpoint_info" {
  providers                    = { aws = aws.aft_management_account_admin }
  source                       = "../../modules/ssm_parameter_by_path/"
  ssm_parameter_path           = local.vpc_endpoint_ssm_parameter_path
  ssm_parameter_path_recursive = true
}



resource "aws_route53_zone_association" "all_other_private_r53_zone_association" {
  count   = length(local.names_of_asso_service)
  vpc_id  = aws_vpc.shared_dev_vpc.id
  zone_id = module.vpc_endpoint_info.param_name_values[join("", [local.vpc_endpoint_ssm_parameter_path, local.names_of_asso_service[count.index]])]
}
provider "aws" {
  
}

locals {
    names_of_asso_service = [
    "sns_zone_id",
    "sqs_zone_id",
    "rds_zone_id",
    "elasticache_zone_id",
    "backup_zone_id",
    "ecr_dkr_zone_id",
    "eks_zone_id",
    "ecs_zone_id",
    "glue_zone_id",
    "elasticbeanstalk_zone_id",
    "email_smtp_zone_id"
  ]

  vpc_endpoint_ssm_parameter_path = "/mm/aft/account_customization/output/account-lz2.0-common/"
}