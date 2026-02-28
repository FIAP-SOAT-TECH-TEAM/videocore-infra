output "cloudfront_url" {
  description = "URL pública do CloudFront"
  value       = "https://${aws_cloudfront_distribution.cf_distribution.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "ID da distribuição CloudFront"
  value       = aws_cloudfront_distribution.cf_distribution.id
}

output "cloudfront_distribution_domain" {
  description = "Domain name da distribuição CloudFront"
  value       = aws_cloudfront_distribution.cf_distribution.domain_name
}