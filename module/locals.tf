locals {
  name = var.env != "" ? "${var.component_name}-${var.env}" : var.component_name
}