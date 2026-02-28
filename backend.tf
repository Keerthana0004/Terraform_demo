## creation de s3

resource "aws_s3_bucket" "terraform_state" {
  bucket = "france-bucket2"
  acl    = "private"
}
## Create a DynamoDB Table for State Locking

resource "aws_dynamodb_table" "terraform_lock" {
  name           = "terraform_lock"
  hash_key       = "LockID"
  read_capacity  = 5
  write_capacity = 5

  attribute {
    name = "LockID"
    type = "S"
  }
}




## attach

terraform {
  backend "s3" {

  
  bucket         = "france-bucket2"
    key            = "terraform-week7/projet/terraform.tfstate"
    region         = "us-east-1" # Change to your desired region
    encrypt        = true
    dynamodb_table = "terraform_lock"
  }

}

  

