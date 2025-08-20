resource "aws_redshiftserverless_namespace" "reddit_ns" {
  namespace_name = "reddit_namespace"
  admin_username = "adminuser"
  admin_user_password = "YourStrongPassword123!"
}

resource "aws_redshiftserverless_workgroup" "reddit_wg" {
  workgroup_name = "reddit_workgroup"
  namespace_name = aws_redshiftserverless_namespace.reddit_ns.namespace_name
  base_capacity  = 32
}


resource "aws_iam_role" "redshift_role" {
  name = "AmazonRedshiftS3AccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "redshift.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "redshift_s3_attach" {
  role       = aws_iam_role.redshift_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# Attach role to Redshift workgroup
resource "aws_redshiftserverless_workgroup" "reddit_wg_update" {
  workgroup_name = aws_redshiftserverless_workgroup.reddit_wg.workgroup_name
  namespace_name = aws_redshiftserverless_namespace.reddit_ns.namespace_name

  config_parameters = {
    enhancedVpcRouting = "false"
  }

  iam_roles = [aws_iam_role.redshift_role.arn]
}
