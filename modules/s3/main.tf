# S3 Bucket for storing static assets
resource "aws_s3_bucket" "bitcot_bucket" {
  bucket = "alivenews.online"

  tags = {
    Name = "Bitcot S3 Bucket"
  }
}

# S3 Bucket Public Access Block (Disable public access, we use OAC)
resource "aws_s3_bucket_public_access_block" "bitcot_bucket_access" {
  bucket = aws_s3_bucket.bitcot_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# S3 Bucket Policy to allow CloudFront access
resource "aws_s3_bucket_policy" "bitcot_bucket_policy" {
  bucket = aws_s3_bucket.bitcot_bucket.id
  policy = jsonencode({
    Version   = "2012-10-17"
    Id        = "PolicyForCloudFrontPrivateContent"
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "arn:aws:s3:::alivenews.online/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = "arn:aws:cloudfront::908027399760:distribution/EXYGVZPNOZAFL"
          }
        }
      }
    ]
  })
}