#-------------------------------------------------------------------------------------------------------
# Amazon SNS Amazon SQS Amazon SES[email-smtp] Amazon RDS Amazon ElastiCache AWS Backup Amazon ECR Amazon EKS 
# Amazon ECS AWS Glue AWS Elastic Beanstalk vpc endpoint route 53 setting to share with all accounts vpc
resource "aws_route53_zone" "all_endpoint_route53_zone" {
  # count         = length(local.names_of_service)
  for_each      = toset(local.names_of_service)
  name          = "${each.key}.ap-south-1.amazonaws.com"
  comment       = "Private hosted zone for AWS LZ in common services account for all accounts"
  force_destroy = false
  tags          = local.common_tags
  vpc {
    vpc_id     = aws_vpc.comsrv_vpc.id
    vpc_region = local.primary_region
  }

  lifecycle {
    ignore_changes = all
  }

  depends_on = [
    aws_vpc.comsrv_vpc
  ]
}

# Authorize application vpcs to be associated with core private hosted zone
resource "aws_route53_vpc_association_authorization" "all_other_private_amazon_r53_zone_assoc" {
  count   = length(local.vpc_endpoint_authorization_list)
  vpc_id  = module.aft_accounts_info.param_name_values["${local.ssm_parameter_path}${local.vpc_endpoint_authorization_list[count.index].account_name}/vpc_id"]
  zone_id = local.vpc_endpoint_authorization_list[count.index].endpoint_hz_id
}

# Endpoint creation for all other services
resource "aws_vpc_endpoint" "all_other_endpoint_service" {
  # count             = length(local.names_of_service)
  for_each          = toset(local.names_of_service)
  vpc_id            = aws_vpc.comsrv_vpc.id
  service_name      = "com.amazonaws.ap-south-1.${each.key}"
  vpc_endpoint_type = "Interface"

  security_group_ids = [
    aws_security_group.allow_endpoints.id,
  ]

  subnet_ids          = [data.aws_subnet.private_subnet_aza.id, data.aws_subnet.private_subnet_azb.id]
  private_dns_enabled = false

  tags = merge(
    { "Name" : "${each.key}_endpoint_service" }
  )

  depends_on = [
    aws_security_group.allow_endpoints,
    aws_route53_zone.all_endpoint_route53_zone
  ]

}

#Commit to create the s3 Record
resource "aws_route53_record" "all_other_private_r53_a_record" {
  # count   = length(local.names_of_service)
  for_each = toset(local.names_of_service)
  zone_id  = aws_route53_zone.all_endpoint_route53_zone[each.key].id
  name     = "${each.key}.ap-south-1.amazonaws.com"
  type     = "A"

  alias {
    name                   = aws_vpc_endpoint.all_other_endpoint_service[each.key].dns_entry[0].dns_name
    zone_id                = aws_vpc_endpoint.all_other_endpoint_service[each.key].dns_entry[0].hosted_zone_id
    evaluate_target_health = true
  }

  depends_on = [
    aws_vpc_endpoint.all_other_endpoint_service
  ]
}
