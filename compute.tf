resource "aws_instance" "web_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  
  
  vpc_security_group_ids = [aws_security_group.web_sg.id]
  subnet_id              = aws_subnet.viva_subnet.id

  tags = { Name = "Web-Server" }
}
