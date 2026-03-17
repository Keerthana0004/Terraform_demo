

# ❌ S3 bucket with no encryption and public access
resource "aws_s3_bucket" "public_data" {
  bucket = "my-public-data-bucket"
  acl    = "public-read-write"

  versioning {
    enabled = false
  }

  tags = {
    Name = "Public Data Bucket"
  }
}

# ❌ Security group with all ports open to the internet
resource "aws_security_group" "wide_open_sg" {
  name        = "wide-open-sg"
  description = "Dangerously open security group"
  vpc_id      = aws_vpc.splunk-vpc.id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All TCP ports open to the world"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH open to the world"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ❌ EC2 instance with no monitoring, using the wide-open security group
resource "aws_instance" "unprotected_server" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.wide_open_sg.id]
  subnet_id              = aws_subnet.splunk-public-subnet-1.id

  metadata_options {
    http_tokens = "optional"
  }

  monitoring = false

  tags = {
    Name = "Unprotected Server"
  }
}

# ❌ IAM policy with wildcard permissions
resource "aws_iam_role_policy" "overprivileged" {
  name = "overprivileged-policy"
  role = "admin-role"

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
