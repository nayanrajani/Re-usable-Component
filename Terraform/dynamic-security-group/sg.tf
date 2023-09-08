resource "aws_security_group" "allow_endpoints" {
  name        = "sg"
  description = "allow for ssm, ssmmessages and ec2messages vpc endpoint"
  vpc_id      = aws_vpc.VPC_ID.id   # Add VPC ID

  dynamic "ingress" {
    for_each = local.rules
    content {
      description = "allow for all"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ingress.value.cidr_blocks
    }
  }

  ingress {
    description = "allow for ssm, ssmmessages and ec2messages vpc endpoint"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [local.primary_vpc_cidr]
  }

  tags = merge(
    { "Name" : "sg" }
  )

}