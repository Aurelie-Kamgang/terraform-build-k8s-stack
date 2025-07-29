resource "random_string" "suffix" {
  length  = 9
  special = false
  upper   = false
  lower   = true
}

resource "aws_s3_bucket" "this" {
  bucket        = "${var.bucket_prefix}${random_string.suffix.result}"
  force_destroy = true
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id
  acl    = "private"
  depends_on = [aws_s3_bucket_ownership_controls.this]
}

# 1. Policy S3 pour Get/Put dans ton bucket
resource "aws_iam_policy" "ec2_s3_access" {
  name        = "ec2_s3_access"
  description = "Allow EC2 to Get/Put join_command.sh on our S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["s3:GetObject","s3:PutObject"]
      Resource = [
        aws_s3_bucket.this.arn,
        "${aws_s3_bucket.this.arn}/*"
      ]
    }]
  })
}

# 2. Rôle EC2 qui peut assumer cette policy
resource "aws_iam_role" "ec2_s3_role" {
  name = "ec2_s3_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

# 3. Attachement de la policy au rôle
resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_s3_role.name
  policy_arn = aws_iam_policy.ec2_s3_access.arn
}

# 4. Instance Profile à rattacher à l'EC2
resource "aws_iam_instance_profile" "ec2_s3_profile" {
  name = "ec2_s3_profile"
  role = aws_iam_role.ec2_s3_role.name
}