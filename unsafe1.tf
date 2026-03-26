

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
