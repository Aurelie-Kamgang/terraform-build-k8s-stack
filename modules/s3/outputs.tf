output "bucket_name" {
  description = "Name of the created S3 bucket"
  value       = aws_s3_bucket.this.bucket
}

# (2) ARN du bucket (si besoin)
output "bucket_arn" {
  description = "L'ARN du bucket S3"
  value       = aws_s3_bucket.this.arn
}

# (3) Instance Profile pour EC2
output "instance_profile_name" {
  description = "Le nom de l'IAM Instance Profile à passer aux EC2"
  value       = aws_iam_instance_profile.ec2_s3_profile.name
}