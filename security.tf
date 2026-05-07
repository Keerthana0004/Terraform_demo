resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  vpc_id      = aws_vpc.viva_vpc.id

  # 🔴 RISK: Open to 0.0.0.0/0
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
