module "servers" {
  for_each       = var.components
  source         = "./module"
  env            = var.env
  instance_type  = each.value["instance_type"]
  component_name = each.value["name"]
  password       = lookup(each.value, "password", "null")
}
