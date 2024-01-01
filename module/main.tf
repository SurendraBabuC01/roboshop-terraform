resource "aws_instance" "instance" {
  ami                    = data.aws_ami.centos.image_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = var.name
  }
}

resource "aws_route53_record" "records" {
  zone_id  = "Z08550883SIRHNRK693H1"
  name     = "${var.name}-dev.surendrababuc01.online"
  type     = "A"
  ttl      = 30
  records  = [aws_instance.instance[var.name].private_ip]
}

resource "null_resource" "provisioner" {
  depends_on = [aws_instance.instance, aws_route53_record.records]
  provisioner "remote-exec" {

    connection {
      type     = "ssh"
      user     = "centos"
      password = "DevOps321"
      host     = aws_instance.instance[var.name].private_ip
    }

    inline = [
      "rm -rf roboshop-shell",
      "git clone https://github.com/SurendraBabuC01/roboshop-shell.git",
      "cd roboshop-shell",
      "sudo bash ${var.name}.sh ${lookup(var.password, "password", "null")}"
    ]
  }

}