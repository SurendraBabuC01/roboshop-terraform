module "vpc" {
  source = "git::https://github.com/SurendraBabuC01/tf-module-vpc.git"

  for_each               = var.vpc
  cidr_block             = each.value["cidr_block"]
  tags                   = local.tags
  env                    = var.env
  default_vpc_id         = var.default_vpc_id
  default_vpc_cidr       = var.default_vpc_cidr
  default_route_table_id = var.default_route_table_id
  subnets                = each.value["subnets"]
}

#module "docdb" {
#  source = "git::https://github.com/SurendraBabuC01/tf-module-docdb.git"
#
#  for_each       = var.docdb
#  name           = each.value["name"]
#  port_no        = each.value["port_no"]
#  engine_version = each.value["engine_version"]
#  instance_count = each.value["instance_count"]
#  instance_class = each.value["instance_class"]
#  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
#  allow_db_cidr  = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
#
#  vpc_id  = local.vpc_id
#  tags    = local.tags
#  env     = var.env
#  kms_arn = var.kms_arn
#}
#
#module "rds" {
#  source = "git::https://github.com/SurendraBabuC01/tf-module-rds.git"
#
#  for_each       = var.rds
#  name           = each.value["name"]
#  port_no        = each.value["port_no"]
#  engine_version = each.value["engine_version"]
#  instance_count = each.value["instance_count"]
#  instance_class = each.value["instance_class"]
#  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
#  allow_db_cidr  = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
#
#  vpc_id  = local.vpc_id
#  tags    = local.tags
#  env     = var.env
#  kms_arn = var.kms_arn
#}
#
#module "elasticache" {
#  source = "git::https://github.com/SurendraBabuC01/tf-module-elasticache.git"
#
#  for_each                = var.elasticache
#  name                    = each.value["name"]
#  port_no                 = each.value["port_no"]
#  engine_version          = each.value["engine_version"]
#  num_node_groups         = each.value["num_node_groups"]
#  node_type               = each.value["node_type"]
#  replicas_per_node_group = each.value["replicas_per_node_group"]
#  subnet_ids              = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
#  allow_db_cidr           = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
#
#  vpc_id  = local.vpc_id
#  tags    = local.tags
#  env     = var.env
#  kms_arn = var.kms_arn
#}
#
#module "rabbitmq" {
#  source = "git::https://github.com/SurendraBabuC01/tf-module-amazon-mq.git"
#
#  for_each      = var.rabbitmq
#  name          = each.value["name"]
#  port_no       = each.value["port_no"]
#  instance_type = each.value["instance_type"]
#  subnet_ids    = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
#  allow_db_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_db_cidr"], null), "subnet_cidrs", null)
#
#  vpc_id       = local.vpc_id
#  tags         = local.tags
#  env          = var.env
#  kms_arn      = var.kms_arn
#  bastion_cidr = var.bastion_cidr
#}

module "alb" {
  source = "git::https://github.com/SurendraBabuC01/tf-module-alb.git"

  for_each       = var.alb
  name           = each.value["name"]
  internal       = each.value["internal"]
  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  allow_alb_cidr = each.value["name"] == "public" ? ["0.0.0.0/0"] : lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_alb_cidr"], null), "subnet_cidrs", null)

  vpc_id = local.vpc_id
  tags   = local.tags
  env    = var.env
}

module "app" {
  #  depends_on = [module.vpc, module.docdb, module.rds, module.elasticache, module.rabbitmq, module.alb]
  depends_on = [module.vpc, module.alb]
  source     = "git::https://github.com/SurendraBabuC01/tf-module-app.git"

  for_each          = var.app
  instance_type     = each.value["instance_type"]
  name              = each.value["name"]
  desired_capacity  = each.value["desired_capacity"]
  max_size          = each.value["max_size"]
  min_size          = each.value["min_size"]
  app_port          = each.value["app_port"]
  listener_priority = each.value["listener_priority"]
  dns_name          = each.value["name"] == "frontend" ? each.value["dns_name"] : "${each.value["name"]}.${var.env}}"

  subnet_ids     = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["subnet_name"], null), "subnet_ids", null)
  vpc_id         = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  allow_app_cidr = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnets", null), each.value["allow_app_cidr"], null), "subnet_cidrs", null)
  listener_arn   = lookup(lookup(module.alb, each.value["lb_type"], null), "listener_arn", null)
  alb_dns_name   = lookup(lookup(module.alb, each.value["lb_type"], null), "dns_name", null)

  env          = var.env
  bastion_cidr = var.bastion_cidr
  tags         = local.tags
  domain_name  = var.domain_name
  domain_id    = var.domain_id
}