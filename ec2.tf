## Ec2 instance 

resource "aws_instance" "ec2-demo" {
  ami                    = "ami-0a887e401f7654935"
  vpc_security_group_ids = [aws_security_group.splunk-sg.id]
  instance_type          = "t2.small"
  key_name               = "ec2-demo"
  subnet_id              = aws_subnet.public_subnet1.id
  user_data              = file("setup1.sh")
  tags = {
    Name = "Terraform instances"
    env  = "Dev"
  }


}