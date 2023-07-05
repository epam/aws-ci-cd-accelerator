output "vpc_id" {
  value = aws_vpc.core.id
}

output "vpc_arn" {
  value = aws_vpc.core.arn
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "application_https_sg_id" {
  value = aws_security_group.application_https.id
}

output "application_https_sg_name" {
  value = aws_security_group.application_https.name
}

output "application_80_sg_id" {
  value = aws_security_group.application_http.id
}

output "application_80_sg_name" {
  value = aws_security_group.application_http.name
}
output "application_sg_nat" {
  value = aws_security_group.application_nat.id
}
output "atlantis_sg_id" {
  value = aws_security_group.atlantis.id
}

output "atlantis_sg_name" {
  value = aws_security_group.atlantis.name
}
output "public_subnet_ids" {
  value = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  value = aws_subnet.private.*.id
}

output "route_table_public_id" {
  value = aws_route_table.public.id
}

output "route_table_private_id" {
  value = aws_route_table.private.id
}

output "nat_gateway" {
  value = aws_nat_gateway.nat_gw.id
}

output "project" {
  value = var.project
}

output "nat_gw_ip" {
  value = var.enable_eip == true ? aws_eip.nat_gw_ip[0].id : var.eip
}

output "aws_acm_certificate_arn" {
  value = module.acm.aws_acm_certificate_arn
}
output "aws_acm_certificate" {
  value = module.acm.aws_acm_certificate_id
}
output "aws_acm_certificate_usa" {
  value = module.acm_usa.aws_acm_certificate_id
}
output "aws_acm_certificate_usa_arn" {
  value = module.acm_usa.aws_acm_certificate_arn
}

output "atlantis_ecr_repository" {
  value = aws_ecr_repository.atlantis.repository_url
}

output "tfstate_bucket_policy_arn" {
  value = aws_iam_policy.tfstate_policy.arn
}

#output "application_db_sg_id" {
#  value = aws
#}