provider "aws" {
  region = var.region
}

locals {
  az1 = "${var.region}a"
  az2 = "${var.region}b"

  # cidrsubnet() function creates a Cidr address in the VpcCidr https://www.terraform.io/docs/configuration/functions/cidrsubnet.html.
  public_cidr_block1 = cidrsubnet(var.vpcCidr, 8, 0)
  public_cidr_block2 = cidrsubnet(var.vpcCidr, 8, 1)
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "ansible-poc-${var.environment}-vpc"
  cidr = var.vpcCidr

  azs            = [local.az1, local.az2]
  public_subnets = [local.public_cidr_block1, local.public_cidr_block2]

  tags = {
    terraform   = "true"
    environment = var.environment
  }
}