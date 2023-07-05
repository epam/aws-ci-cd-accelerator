# Create CF Stack for tests
# Original solution: https://s3.amazonaws.com/solutions-reference/distributed-load-testing-on-aws/latest/distributed-load-testing-on-aws.template
resource "aws_cloudformation_stack" "dlt_test" {
  name         = "DLT-Load-Test-${var.repo_name}-${var.region_name}"
  capabilities = ["CAPABILITY_IAM"]
  template_url = "https://${var.storage_bucket}.s3.${var.region}.amazonaws.com/dlt.yml"

  parameters = {
    RepoName         = var.repo_name
    RegionName       = var.region_name
    DNSAlias         = "${var.repo_name}-${var.region_name}-dlt.${var.route53_zone_name}"
    ACMCertificate   = var.aws_acm_certificate_arn
    AdminName        = var.admin_name
    AdminEmail       = var.admin_email
    ExistingVPCId    = var.vpc_id
    ExistingSubnetA  = var.private_subnet_ids[0]
    ExistingSubnetB  = var.private_subnet_ids[1]
    VpcCidrBlock     = var.vpc_cidr_block
    SubnetACidrBlock = var.private_subnets[0]
    SubnetBCidrBlock = var.private_subnets[1]
  }
  on_failure = "DELETE"

#  provisioner "local-exec" {
#    when        = destroy
#    interpreter = ["/bin/bash", "-c"]
#    command     = <<-EOF
#
#        aws s3 rb "s3://${self.outputs.Bucket1}" --force
#        aws s3 rb "s3://${self.outputs.Bucket2}" --force
#        aws s3 rb "s3://${self.outputs.Bucket3}" --force
#      EOF
#  }


}

data "aws_cloudfront_distribution" "test" {
  id = aws_cloudformation_stack.dlt_test.outputs.DistributionId
}

data "aws_route53_zone" "poc" {
  name = var.route53_zone_name
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.poc.zone_id
  name    = "${var.repo_name}-${var.region_name}-dlt"
  type    = "A"

  alias {
    name                   = data.aws_cloudfront_distribution.test.domain_name
    zone_id                = data.aws_cloudfront_distribution.test.hosted_zone_id
    evaluate_target_health = false
  }
}