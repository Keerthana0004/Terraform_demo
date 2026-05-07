# ❌ S3 bucket - no encryption, public ACL
resource "aws_s3_bucket" "exposed_logs" {
  bucket = "company-exposed-logs"
  acl    = "public-read"

  versioning {
    enabled = false
  }

  tags = {
    Name = "Exposed Logs Bucket"
  }
}

# ❌ Security group - RDP open to the world
resource "aws_security_group" "rdp_open" {
  name        = "rdp-open-sg"
  description = "RDP open to the internet"
  vpc_id      = aws_vpc.splunk-vpc.id

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "RDP open to the world"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ❌ IAM role with wildcard trust policy
resource "aws_iam_role_policy" "full_access" {
  name = "full-access-policy"
  role = "dev-role"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "*"
        Resource = "*"
      }
    ]
  })
}

# ❌ EC2 instance with no monitoring in the open security group
resource "aws_instance" "risky_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.large"

  vpc_security_group_ids = [aws_security_group.rdp_open.id]
  subnet_id              = aws_subnet.public_subnet1.id

  monitoring = false

  tags = {
    Name = "Risky Server"
  }
}
