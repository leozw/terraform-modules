resource "aws_security_group" "custom" {
  name                   = format("%s-sg", var.settings.sg_name)
  vpc_id                 = var.settings.vpc_id
  revoke_rules_on_delete = true

  dynamic "ingress" {
    iterator = ingress
    for_each = var.settings.ingress
    content {
      from_port       = ingress.value["from_port"] == "" ? "22" : ingress.value["from_port"]
      to_port         = ingress.value["to_port"] == "" ? "22" : ingress.value["to_port"]
      protocol        = ingress.value["protocol"] == "" ? "tcp" : ingress.value["protocol"]
      security_groups = ingress.value["security_groups"] == null ? [] : ingress.value["security_groups"]
      cidr_blocks     = [
        for ip in ingress.value["list_of_cidrs"] :
        ip
      ]
    }
  }

  egress {
    protocol    = -1
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge({ 
    Name        = format("%s-sg", var.settings.sg_name)
    Vpc_ID      = var.settings.vpc_id
    Vpc_Name    = var.settings.vpc_name
    }, 
    var.settings.tags)
}
