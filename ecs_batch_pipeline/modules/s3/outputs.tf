output "source_bucket_name" {
  description = "Name of the source bucket"
  value       = aws_s3_bucket.source.bucket
}

output "destination_bucket_name" {
  description = "Name of the destination bucket"
  value       = aws_s3_bucket.destination.bucket
}
