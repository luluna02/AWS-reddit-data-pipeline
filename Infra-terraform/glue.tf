
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "glue/reddit_glue_job.py"
  source = "${path.module}/glue/script.py"
  etag   = filemd5("${path.module}/glue/script.py")
}

# IAM Role for Glue
resource "aws_iam_role" "glue_role" {
  name = "reddit_glue_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = {
        Service = "glue.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach policy for S3 + Glue access
resource "aws_iam_role_policy_attachment" "glue_service_policy" {
  role       = aws_iam_role.glue_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

# Add custom S3 access
resource "aws_iam_role_policy" "glue_s3_access" {
  name = "reddit_glue_s3_access"
  role = aws_iam_role.glue_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::${var.bucket_name}",
          "arn:aws:s3:::${var.bucket_name}/*"
        ]
      }
    ]
  })
}



# Glue Job
resource "aws_glue_job" "reddit_glue_job" {
  name     = "reddit_glue_job"
  role_arn = aws_iam_role.glue_role.arn


  command {
    name            = "glueetl"
    script_location = "s3://${var.bucket_name}/${aws_s3_object.glue_script.key}"
    python_version  = "3"
  }

  default_arguments = {
    "--job-language" = "python"
    "--enable-metrics" = ""
    "--enable-continuous-cloudwatch-log" = "true"
    "--job-bookmark-option" = "job-bookmark-disable"

    # Pass in input/output paths to your script
    "--SOURCE_PATH" = "s3://${var.bucket_name}/raw/reddit_20250813.csv"
    "--TARGET_PATH" = "s3://${var.bucket_name}/transformed/"
    "--SOURCE_FORMAT" = "csv"
    "--TARGET_FORMAT" = "csv"
  }

  glue_version      = "4.0"
  max_retries       = 0
  timeout           = 10
  number_of_workers = 2
  worker_type       = "G.1X"
}
