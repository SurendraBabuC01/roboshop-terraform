data "aws_ami" "centos" {
  owners      = ["973714476881"]
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
}


data "aws_security_group" "allow-all" {
  name = "allow-all"
}

variable "components" {
  default = {
    frontend = {
      name          = "frontend"
      instance_type = "t3.small"
    }
  /*  mongodb = {
      name          = "mongodb"
      instance_type = "t3.small"
    }
    catalogue = {
      name          = "catalogue"
      instance_type = "t3.micro"
    }
    redis = {
      name          = "redis"
      instance_type = "t3.small"
    }
    user = {
      name          = "user"
      instance_type = "t3.micro"
    }
    cart = {
      name          = "cart"
      instance_type = "t3.micro"
    }
    mysql = {
      name          = "mysql"
      instance_type = "t3.small"
    }
    shipping = {
      name          = "shipping"
      instance_type = "t3.medium"
    }
    rabbitmq = {
      name          = "rabbitmq"
      instance_type = "t3.small"
    }
    payment = {
      name          = "payment"
      instance_type = "t3.small"
    }*/
  }
}


resource "aws_instance" "instance" {
  for_each               = var.components
  ami                    = data.aws_ami.centos.image_id
  instance_type          = each.value["instance_type"]
  vpc_security_group_ids = [data.aws_security_group.allow-all.id]

  tags = {
    Name = each.value["name"]
  }
}

resource "aws_route53_record" "records" {
  for_each = var.components
  zone_id  = "Z08550883SIRHNRK693H1"
  name     = "${each.value["name"]}-dev.surendrababuc01.online"
  type     = "A"
  ttl      = 30
  records  = [aws_instance.instance[each.key].private_ip]
}

