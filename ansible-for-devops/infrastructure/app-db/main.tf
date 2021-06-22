provider "aws" {
  region = var.region
}

# Calculated local values.
locals {
  region         = data.terraform_remote_state.vpc.outputs.region
  environment    = data.terraform_remote_state.vpc.outputs.environment
  vpc_id         = data.terraform_remote_state.vpc.outputs.vpc_id
  public_subnets = data.terraform_remote_state.vpc.outputs.public_subnets

  ami_id    = var.ami_id == null ? data.aws_ami.amazon_linux2[0].id : var.ami_id
  count_ami = var.ami_id == null ? 1 : 0

  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]

  ssh_port   = 22
  http_port  = 80
  mysql_port = 3306

  security_groups = {
    "app" = aws_security_group.app.id
    "db"  = aws_security_group.db.id
  }
}

# Use this data source to retrieve state data from a Terraform local backend - vpc layer.
data "terraform_remote_state" "vpc" {
  backend = "local"

  config = {
    path = "../vpc/terraform.tfstate"
  }
}

# Data source to get the latest AMI for Amazon Linux2.
data "aws_ami" "amazon_linux2" {
  count = local.count_ami

  most_recent = true

  owners = ["amazon"]

  filter {
    name = "name"

    values = [
      "amzn2-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

# Security group for the APP EC2 instances.
resource "aws_security_group" "app" {
  name        = "app-sg"
  description = "Security Group for APP EC2 Instances"
  vpc_id      = local.vpc_id

  tags = {
    Name        = "app-sg"
    terraform   = true
    environment = local.environment
  }
}

# Security group rules are defined as separate resources for more flexibility.
resource "aws_security_group_rule" "allow_http_inbound" {
  type              = "ingress"
  description       = "HTTP from anywhere"
  security_group_id = aws_security_group.app.id

  from_port   = local.http_port
  to_port     = local.http_port
  protocol    = local.tcp_protocol
  cidr_blocks = local.all_ips
}

# Security group for the DB EC2 instance.
resource "aws_security_group" "db" {
  name        = "db-sg"
  description = "Security Group for DB EC2 Instance"
  vpc_id      = local.vpc_id

  tags = {
    Name        = "db-sg"
    terraform   = true
    environment = local.environment
  }
}

# Incomming traffic on MySQL port only allowed from app-sg security group.
resource "aws_security_group_rule" "allow_mysql_inbound" {
  type              = "ingress"
  description       = "MySQL from app-sg"
  security_group_id = aws_security_group.db.id

  from_port                = local.mysql_port
  to_port                  = local.mysql_port
  protocol                 = local.tcp_protocol
  source_security_group_id = aws_security_group.app.id
}

# Allows all outbound requests. Unlike creating an SG in the AWS console, egress rules are NOT automatically created!
resource "aws_security_group_rule" "allow_all_outbound" {
  for_each = local.security_groups

  type              = "egress"
  security_group_id = each.value

  from_port   = local.any_port
  to_port     = local.any_port
  protocol    = local.any_protocol
  cidr_blocks = local.all_ips
}

# Deploy 2 x APP EC2 instances.
resource "aws_instance" "app" {
  count = 2

  ami           = local.ami_id
  instance_type = var.app_instance_type

  key_name               = var.key_name
  monitoring             = true
  subnet_id              = local.public_subnets[0]
  vpc_security_group_ids = [aws_security_group.app.id]

  root_block_device {
    volume_type = "gp3"
    volume_size = "50"
    encrypted   = "true"
  }

  # user_data = data.template_file.user_data.rendered

  # iam_instance_profile = aws_iam_instance_profile.main.name

  tags = {
    Name        = "app-0${count.index}"
    terraform   = true
    environment = var.environment
  }
}
