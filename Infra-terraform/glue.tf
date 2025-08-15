
resource "aws_s3_object" "glue_script" {
  bucket = aws_s3_bucket.my_bucket.bucket
  key    = "glue/reddit_glue_job.py"
  source = "${path.module}/glue/script.py"
  etag   = filemd5("${path.module}/glue/script.py")
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
