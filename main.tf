provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "terraform_state_bucket" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "terraform_state_lock_table" {
  name           = var.lock_table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

variable "aws_region" {
  description = "The AWS region where resources will be created"
  type        = string
  default     = "us-west-2"  // You can change the default value as needed
}

variable "bucket_name" {
  description = "The name of the S3 bucket to be created for Terraform state"
  type        = string
  default = "test"
}

variable "environment" {
  description = "The environment for which the S3 bucket is created (e.g., development, staging, production)"
  type        = string
  default     = "development"  // You can change the default value as needed
}

variable "lock_table_name" {
  description = "The name of the DynamoDB table for Terraform state locking"
  type        = string
  default = "terraform-dynamo-db-table"
}
