output "ec2_names" {
  value = [
    for i in values(aws_instance.ec2) :
    try(i.tags["Name"], "no-name")
  ]
}


output "ec2_ids" {
  value = [
    for i in values(aws_instance.ec2) :
    i.id
  ]
}

output "ec2_public_ip" {
  value = [
    for i in values(aws_instance.ec2) :
    i.public_ip
  ]
}
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
