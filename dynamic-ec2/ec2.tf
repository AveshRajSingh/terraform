locals {
   ami_map = {
    amazon_linux = data.aws_ami.amazon_linux.id
    ubuntu       = data.aws_ami.ubuntu.id
  }
  ec2_instances = flatten([
    for cfg in var.ec2_config : [
      for i in range(cfg.count) : {
        ami           = local.ami_map[cfg.ami_key]
        name          = cfg.name
        instance_type = cfg.instance_type
        subnet_id     = aws_subnet.subnet[i % length(aws_subnet.subnet)].id
        index         = i
      }
    ]
  ])
}

resource "aws_instance" "ec2" {
  for_each = {
    for idx, inst in local.ec2_instances :
    "${inst.name}-${idx}" => inst
  }

  ami           = each.value.ami
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id

  tags = {
    Name = "${each.value.name}-${each.value.index}"
  }
}

