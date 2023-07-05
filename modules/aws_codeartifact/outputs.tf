output "codeartifact_domain" {
  value = aws_codeartifact_domain.project_domain.domain
}

output "codeartifact_repo" {
  value = aws_codeartifact_repository.maven.repository
}