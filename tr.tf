provider "aws" {
  region = "us-east-1"
}

# ---------------- SAFE RESOURCE ----------------
resource "aws_s3_bucket" "secure_bucket" {
  bucket = "my-secure-bucket-12345"

  tags = {
    Name        = "SecureBucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_public_access_block" "secure_block" {
  bucket = aws_s3_bucket.secure_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# ---------------- MISCONFIGURED RESOURCE ----------------
resource "aws_s3_bucket" "insecure_bucket" {
  bucket = "my-insecure-bucket-12345"
  acl    = "public-read"   # ❌ Public access enabled
}

# ---------------- SAFE EC2 ----------------
resource "aws_instance" "safe_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "required"   # ✅ IMDSv2 enforced
  }

  tags = {
    Name = "SafeInstance"
  }
}

# ---------------- MISCONFIGURED EC2 ----------------
resource "aws_instance" "insecure_ec2" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  metadata_options {
    http_tokens = "optional"   # ❌ IMDSv1 allowed
  }

  tags = {
    Name = "InsecureInstance"
  }
}

# ---------------- MISCONFIGURED SECURITY GROUP ----------------
resource "aws_security_group" "open_sg" {
  name        = "open_sg"
  description = "Allow all traffic"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ Open to world
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]   # ❌ Open outbound
  }
}

# ---------------- SAFE SECURITY GROUP ----------------
resource "aws_security_group" "restricted_sg" {
  name        = "restricted_sg"
  description = "Restricted access"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"]   # ✅ Limited access
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
