module "vpc" {
  source = "git::https://github.com/SurendraBabuC01/tf-module-vpc.git"

  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  tags       = local.tags
  env        = var.env
  subnets    = each.value["subnets"]
}

module "web" {
  source = "git::https://github.com/SurendraBabuC01/tf-module-app.git"

  for_each = var.app
  instance_type = each.value["instance_type"]
  subnet_id = element(lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null), 0)
}