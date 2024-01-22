locals {
  name = var.env != "" ? "${var.component_name}-${var.env}" : var.component_name
  db_servers = [
    "rm -rf roboshop-shell",
    "git clone https://github.com/SurendraBabuC01/roboshop-shell.git",
    "cd roboshop-shell",
    "sudo bash ${var.component_name}.sh ${var.password}"
  ]
  app_servers = [
    "sudo labauto ansible",
    "ansible-pull -i localhost, -U https://github.com/SurendraBabuC01/roboshop-ansible.git roboshop.yml -e role_name=${var.component_name} -e env=${env}"
  ]
}