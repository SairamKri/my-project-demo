output "bitcot_bucket_id"{
    value = aws_s3_bucket.bitcot_bucket.id
}

output "bitcot_bucket_arn"{
    value = aws_s3_bucket.bitcot_bucket.arn
}

output "bitcot_bucket_regional_domain_name" {
  value = aws_s3_bucket.bitcot_bucket.bucket_regional_domain_name
}