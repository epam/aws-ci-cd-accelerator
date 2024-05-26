output "aws_acm_certificate_arn" {
  description = "The ARN of the AWS Certificate Manager (ACM) Certificate"
  value       = aws_acm_certificate.acm.arn
}

output "aws_acm_certificate_id" {
  description = "The ID of the AWS Certificate Manager (ACM) Certificate"
  value       = aws_acm_certificate.acm.id
}
