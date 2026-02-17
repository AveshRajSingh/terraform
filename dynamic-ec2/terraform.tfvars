ec2_config = [ {
  ami_key = "amazon_linux"
  name = "amazon-linux-instance"
  instance_type = "t3.micro"
  count = 2
},
{
    ami_key = "ubuntu"
    name = "ubuntu-instance"
    instance_type = "t3.micro"
    count = 2
} ]