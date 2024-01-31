module "vpc" {
  source = "git::https://github.com/SurendraBabuC01/tf-module-vpc.git"

  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  tags       = local.tags
  env        = var.env
}