
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Disable "Block All Public Access"
resource "aws_s3_bucket_public_access_block" "my_bucket_access" {
  bucket                  = aws_s3_bucket.my_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# Attach an S3 access policy to the existing IAM user "lina"
resource "aws_iam_user_policy" "lina_s3_access" {
  name = "lina-s3-access"
  user = "lina"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::${var.bucket_name}"
      },
      {
        Effect   = "Allow"
        Action   = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::${var.bucket_name}/*"
      }
    ]
  })
}


resource "aws_s3_object" "transformed_prefix" {
  bucket  = var.bucket_name       # Use the main bucket
  key     = "transformed/"        # The folder inside the bucket
  content = ""
}

