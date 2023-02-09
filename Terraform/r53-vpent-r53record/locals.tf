locals {
    # ALL Other VPC ENDPOINTS [ses not found]
  names_of_service     = ["sns", "sqs", "rds", "elasticache", "backup", "ecr.dkr", "eks", "ecs", "glue", "elasticbeanstalk", "email-smtp"]
  all_account_list_vpc = ["account-lz2.0-shared-dev", "account-lz2.0-shared-prod", "account-lz2.0-shared-uat",  "account-lz2.0-central-egress", "account-lz2.0-network"]
  vpc_endpoint_authorization_list = flatten([
    for account_name in local.all_account_list_vpc : [
      for endpoint_name in local.names_of_service : {
        account_name   = account_name
        endpoint_hz_id = aws_route53_zone.all_endpoint_route53_zone[endpoint_name].id
      }
    ]
  ])
    # export outputs of type string
  export_output = {
    vpc_id                   = aws_vpc.comsrv_vpc.id
    vpc_cidr                 = aws_vpc.comsrv_vpc.cidr_block
    tgw_attachment_id        = aws_ec2_transit_gateway_vpc_attachment.tgw_network.id
    ssm_endpoint_id          = aws_route53_zone.ssm_endpoint_route53_zone.id
    ssmmessages_endpoint_id  = aws_route53_zone.ssmmessages_endpoint_route53_zone.id
    ec2messages_endpoint_id  = aws_route53_zone.ec2messages_endpoint_route53_zone.id
    s3_endpoint_id           = aws_route53_zone.s3_endpoint_route53_zone.id
    sns_zone_id              = aws_route53_zone.all_endpoint_route53_zone["sns"].id
    sqs_zone_id              = aws_route53_zone.all_endpoint_route53_zone["sqs"].id
    rds_zone_id              = aws_route53_zone.all_endpoint_route53_zone["rds"].id
    elasticache_zone_id      = aws_route53_zone.all_endpoint_route53_zone["elasticache"].id
    backup_zone_id           = aws_route53_zone.all_endpoint_route53_zone["backup"].id
    ecr_dkr_zone_id          = aws_route53_zone.all_endpoint_route53_zone["ecr.dkr"].id
    eks_zone_id              = aws_route53_zone.all_endpoint_route53_zone["eks"].id
    ecs_zone_id              = aws_route53_zone.all_endpoint_route53_zone["ecs"].id
    glue_zone_id             = aws_route53_zone.all_endpoint_route53_zone["glue"].id
    elasticbeanstalk_zone_id = aws_route53_zone.all_endpoint_route53_zone["elasticbeanstalk"].id
    email_smtp_zone_id       = aws_route53_zone.all_endpoint_route53_zone["email-smtp"].id
  }
  # export outputs of type list
  export_list_output = {

  }
}