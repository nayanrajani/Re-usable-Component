#AMI's--------------------------------------------------------------------------
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }

}

# Get latest Windows Server 2012R2 AMI
data "aws_ami" "windows-2012-r2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2012-R2_RTM-English-64Bit-Base-*"]
  }
}
# Get latest Windows Server 2016 AMI
data "aws_ami" "windows-2016" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base*"]
  }
}
# Get latest Windows Server 2019 AMI
data "aws_ami" "windows-2019" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base*"]
  }
}
# Get latest Windows Server 2022 AMI
data "aws_ami" "windows-2022" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-Base*"]
  }
}

#Key-Pair-----------------------------------------------------------------------------------
# Keypair's ARE FETCHED AND PASSED
data "aws_key_pair" "kp-sfdc-windows" {
  key_name = "sfdc_jenkins_windowserver"

  filter {
    name   = "key-name"
    values = ["sfdc_jenkins_windowserver"]
  }
}

#Subnet-------------------------------------------------------------------------------------
data "aws_subnet" "sfdc_private_subnet_aza" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.sfdc_vpc.id]
  }

  filter {
    name   = "availability-zone"
    values = [local.availability_zones[0]]
  }

  filter {
    name   = "cidr-block"
    values = [local.private_subnet_list_app[0]]
  }

}

resource "aws_security_group" "sgp_sfdc_jenkins_window" {
  name        = "sgp_sfdc_jenkins_window"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.sfdc_vpc.id

  ingress {
    description      = "Allowing incoming RDp connection from jumpbox"
    from_port        = 3389
    to_port          = 3389
    protocol         = "tcp"
    cidr_blocks      = ["192.168.58.80/32"]
  }

  ingress {
    description      = "Allowing incoming HTTP connection from jumpbox"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["192.168.58.80/32"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
  # depends_on = [
  #   aws_iam_instance_profile.test_1_profile
  # ]
}

resource "aws_instance" "web" {
  ami                    = data.aws_ami.windows-2022.id
  instance_type          = "m5a.xlarge"
  vpc_security_group_ids = [aws_security_group.sgp_sfdc_jenkins_window.id]

  subnet_id                   = data.aws_subnet.sfdc_private_subnet_aza.id
  associate_public_ip_address = false

  # iam_instance_profile = aws_iam_instance_profile.test_1_profile.name
  key_name             = data.aws_key_pair.kp-sfdc-windows.key_name
    tags = merge(
    {
      Name = "sfdc_jenkins_window"
    },
    local.common_tags
  )

  # root disk
  root_block_device {
    volume_size           = 60
    volume_type           = "gp2"
    delete_on_termination = true
    encrypted             = true
  }
  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = 60
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  depends_on = [
    aws_security_group.sgp_sfdc_jenkins_window,
    # aws_iam_instance_profile.test_1_profile
  ]
}
