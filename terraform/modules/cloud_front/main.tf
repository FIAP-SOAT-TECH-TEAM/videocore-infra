# Assinatura Azure For Studetns bloqueia a criação de um Azure Front Door. Portanto, utilizamos o CloudFront para distribuir o conteúdo do Azure Blob Storage.
# https://learn.microsoft.com/en-us/answers/questions/1729771/unbale-to-create-azure-front-door-service-with-azu

resource "aws_cloudfront_distribution" "cf_distribution" {
  enabled             = true
  comment             = "${var.dns_prefix}-cloudfront-azure-blob"
  default_root_object = "index.html"
  price_class         = var.cloudfront_price_class

  origin {
    domain_name = var.static_website_hostname
    origin_id   = "${var.dns_prefix}-azure-blob-origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "https-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    target_origin_id       = "${var.dns_prefix}-azure-blob-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  tags = {
    Name = "${var.dns_prefix}-cloudfront"
  }
}

resource "null_resource" "update_stgaccount_cors" {
  depends_on = [aws_cloudfront_distribution.cf_distribution]

  triggers = {
    cloudfront_url = local.cloudfront_url
  }

  provisioner "local-exec" {
    command = <<EOT
az storage cors add \
  --account-name ${var.storage_account_name} \
  --services b \
  --methods GET POST PUT DELETE OPTIONS HEAD MERGE \
  --origins ${local.cloudfront_url} \
  --allowed-headers "*" \
  --exposed-headers "*" \
  --max-age 3600
EOT
  }
}