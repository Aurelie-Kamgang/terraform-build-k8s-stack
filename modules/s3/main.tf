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
  bucket     = aws_s3_bucket.this.id
  acl        = "private"
  depends_on = [aws_s3_bucket_ownership_controls.this]
}