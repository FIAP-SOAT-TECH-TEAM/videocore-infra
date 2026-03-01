locals {
  cloudfront_url = "https://${aws_cloudfront_distribution.cf_distribution.domain_name}"
}