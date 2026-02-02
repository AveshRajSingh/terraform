output "ec2_names" {
  value = [
    for i in aws_instance.ec2 :
    try(i.tags["Name"], "no-name")
  ]
}

output "ec2_ids" {
  value = aws_instance.ec2[*].id 
}
output "ec2_public_ip" {
  value = aws_instance.ec2[*].public_ip
}
output "vpc_id" {
  value = aws_vpc.main_vpc.id
}
