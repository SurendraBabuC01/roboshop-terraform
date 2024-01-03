module "database_servers" {
  for_each       = var.database_servers
  source         = "./module"
  env            = var.env
  instance_type  = each.value["instance_type"]
  component_name = each.value["name"]
  password       = lookup(each.value, "password", "null")
  provisioner    = true
}

module "app_servers" {
  depends_on     = [module.database_servers]
  for_each       = var.app_servers
  source         = "./module"
  env            = var.env
  instance_type  = each.value["instance_type"]
  component_name = each.value["name"]
  password       = lookup(each.value, "password", "null")
}



