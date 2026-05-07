provider "aws" {
  region = "us-west-2"
}

# ---------------- VPC (SAFE) ----------------
resource "aws_vpc" "main_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "MainVPC"
  }
}

# ---------------- SUBNET (SAFE) ----------------
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false   # ✅ Private subnet

  tags = {
    Name = "PrivateSubnet"
  }
}

# ---------------- SUBNET (MISCONFIG) ----------------
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = true    # ⚠️ Public exposure (not always bad, but risky)

  tags = {
    Name = "PublicSubnet"
  }
}

# ---------------- IAM ROLE (SAFE-ish) ----------------
resource "aws_iam_role" "safe_role" {
  name = "safe-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
  })
}

# ---------------- IAM POLICY (MISCONFIG) ----------------
resource "aws_iam_policy" "over_permissive_policy" {
  name = "over-permissive-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect   = "Allow",
      Action   = "*",          # ❌ Full access
      Resource = "*"           # ❌ On all resources
    }]
  })
}

# ---------------- ATTACH POLICY (MISCONFIG) ----------------
resource "aws_iam_role_policy_attachment" "attach_bad_policy" {
  role       = aws_iam_role.safe_role.name
  policy_arn = aws_iam_policy.over_permissive_policy.arn
}

# ---------------- RDS INSTANCE (MISCONFIG) ----------------
resource "aws_db_instance" "insecure_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = "password123"   # ❌ Hardcoded weak password
  publicly_accessible  = true            # ❌ Exposed to internet
  skip_final_snapshot  = true            # ❌ No backup on deletion

  tags = {
    Name = "InsecureDB"
  }
}

# ---------------- RDS INSTANCE (SAFE) ----------------
resource "aws_db_instance" "secure_db" {
  allocated_storage    = 20
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  username             = "admin"
  password             = var.db_password   # ✅ Use variable
  publicly_accessible  = false             # ✅ Private
  skip_final_snapshot  = false             # ✅ Backup enabled

  tags = {
    Name = "SecureDB"
  }
}

# ---------------- VARIABLES (SAFE) ----------------
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
