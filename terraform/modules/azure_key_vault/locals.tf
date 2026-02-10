locals {
    aws_access_key_id = regex(
        "aws_access_key_id=([^\n\r]+)",
        var.aws_credentials
    )[0]

    aws_secret_access_key = regex(
        "aws_secret_access_key=([^\n\r]+)",
        var.aws_credentials
    )[0]

    aws_session_token = regex(
        try("aws_session_token=([^\n\r]+)", ""),
        var.aws_credentials
    )[0]
  
    formatted_aws_credentials = join(";", [
        "AWS_ACCESS_KEY_ID=${local.aws_access_key_id}",
        "AWS_SECRET_ACCESS_KEY=${local.aws_secret_access_key}",
        "AWS_REGION=${var.aws_location}",
        "AWS_SESSION_TOKEN=${local.aws_session_token}",
    ])
}