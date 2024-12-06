# Define a map of available services with their configurations
locals {
  service_config = {
    # explam = {
    #   service_name     = "com.amazonaws.${var.region}.<service>"
    #   vpc_endpoint_type = "" # Gateway or Interface
    # }
    s3 = {
      service_name      = "com.amazonaws.${var.region}.s3"
      vpc_endpoint_type = "Gateway"
    }
    kms = {
      service_name      = "com.amazonaws.${var.region}.kms"
      vpc_endpoint_type = "Interface"
      priavte_dns       = true
    }
    rds = {
      service_name      = "com.amazonaws.${var.region}.rds"
      vpc_endpoint_type = "Interface"
      private_dns       = true
    }
  }
}

resource "aws_vpc_endpoint" "endpoints" {
  for_each = { for service in var.endpoints : service => local.service_config[service] }

  vpc_id              = var.vpc_id
  service_name        = each.value.service_name
  subnet_ids          = each.value.vpc_endpoint_type == "Interface" ? var.subnet_ids : null
  vpc_endpoint_type   = each.value.vpc_endpoint_type
  security_group_ids  = each.value.vpc_endpoint_type == "Interface" ? var.security_group_ids : null
  private_dns_enabled = lookup(each.value, "private_dns", false)

  tags = {
    Name = "${var.name}-${each.key}-endpoint"
  }
}

resource "aws_vpc_endpoint_route_table_association" "gateway_associations" {
  for_each = {
    for key, endpoint in aws_vpc_endpoint.endpoints :
    key => endpoint if endpoint.vpc_endpoint_type == "Gateway"
  }

  vpc_endpoint_id = each.value.id
  route_table_id  = var.route_table_id
}
