module "servers" {
  source = "./module"
  for_each = var.components
  env = var.env
  instance_type = each.value["instance_type"]
  name = each.value["name"]
  password = lookup(each.value, "password", "null")
}
