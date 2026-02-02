resource "aws_instance" "ec2" {
  count = length(aws_subnet.subnet) * var.instances_per_subnet

  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type

  subnet_id = aws_subnet.subnet[
    floor(count.index / var.instances_per_subnet)
  ].id

  tags = {
    Name = "ec2-${count.index}"
  }
}

