# ----------------------------------------------------------------------------------------------
# Ingress Setup

# resource "aws_internet_gateway" "ingress_igw_tws" {
#   vpc_id = aws_vpc.tws_vpc.id

#   tags = merge(
#     { "Name" = "igw-aws-ingress-tws" },
#     local.common_tags
#   )
# }

# Edge Association with Main Route Table

resource "aws_route_table_association" "ingress_main_rt_asso__igw_tws" {
  gateway_id     = "igw-0c0cf9bf19354d09f" # Hard Code
  # aws_internet_gateway.ingress_igw_tws.id
  route_table_id = aws_vpc.tws_vpc.main_route_table_id
}

# GWLBEP creation to route traffic from Spoke Account to Inspection Account

resource "aws_vpc_endpoint" "ingress_gwlbenp_tws" {
  count          = length(local.private_subnet_list_gwlbenp)
  subnet_ids      = [element(aws_subnet.private_gwlbenp_subnet.*.id, count.index)]
  vpc_endpoint_type  = "GatewayLoadBalancer"
  service_name      = module.aft_accounts_info.param_name_values["${local.vpc_endpoint_service}ingress_pa_gwlb_enps"]
  vpc_id            = aws_vpc.tws_vpc.id
  tags = merge(
    {
      Name = try(
        local.gwlb_epn_name[count.index],
        format("${local.gwlb_epn_name}-%s001", element(local.zones, count.index))
      )
    },
    local.common_tags
  )
}

# Main Route table Routes to LB Subnets CIDR with GWLBENP

resource "aws_route" "ingress_main_rt_to_lb_subnet_tws" {
  count                  = length(local.private_subnet_list_lb)
  route_table_id         = aws_vpc.tws_vpc.main_route_table_id
  destination_cidr_block = local.private_subnet_list_lb[count.index]
  vpc_endpoint_id        = element(aws_vpc_endpoint.ingress_gwlbenp_tws.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

# LB Route table Routes to 0.0.0.0/0 CIDR with GWLBENP

resource "aws_route" "ingress_lb_rt_to_gwlbenp_tws" {
  count                  = length(local.private_subnet_list_lb)
  route_table_id         = element(aws_route_table.private_lb_rt.*.id, count.index)
  destination_cidr_block = local.open_ingress
  vpc_endpoint_id        = element(aws_vpc_endpoint.ingress_gwlbenp_tws.*.id, count.index)

  timeouts {
    create = "5m"
  }
}

# GWLBENP Route table Routes to 0.0.0.0/0 CIDR with IGW for return route

resource "aws_route" "ingress_gwlbenp_rt_to_return_igw_tws" {
  count                  = length(local.private_subnet_list_gwlbenp)
  route_table_id         = element(aws_route_table.private_gwlbenp_rt.*.id, count.index)
  destination_cidr_block = local.open_ingress
  gateway_id        = "igw-0c0cf9bf19354d09f"
  # aws_internet_gateway.ingress_igw_tws.id

  timeouts {
    create = "5m"
  }
}