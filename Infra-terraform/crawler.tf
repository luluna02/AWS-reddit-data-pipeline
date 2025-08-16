# Glue Database (needed for tables)
resource "aws_glue_catalog_database" "reddit_db" {
  name = "reddit_db"
}

# Glue Crawlers to create tables from S3
# Crawler for raw data
resource "aws_glue_crawler" "raw_crawler" {
  name         = "reddit_raw_crawler"
  role         = aws_iam_role.glue_role.arn
  database_name = aws_glue_catalog_database.reddit_db.name

  s3_target {
    path = "s3://${var.bucket_name}/raw/"
  }

  configuration = jsonencode({
    Version = 1.0
    CrawlerOutput = {
      Partitions = { AddOrUpdateBehavior = "InheritFromTable" }
    }
  })
}
