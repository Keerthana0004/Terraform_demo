output "instance_public_ip" {
  value = aws_instance.ec2-demo.public_ip
}

output "vpc_id" {
  value = aws_vpc.splunk-vpc.id
}

output "public_subnet_ids" {
  value = [
    aws_subnet.public_subnet1.id,
    aws_subnet.public_subnet2.id

  ]
}
output "splunk-vpc_id" {
  value = aws_security_group.splunk-sg.id

}