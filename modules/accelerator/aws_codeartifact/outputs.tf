output "codeartifact_domain" {
  description = "The domain of the CodeArtifact"
  value       = aws_codeartifact_domain.project_domain.domain
}

output "codeartifact_repo" {
  description = "The repository of the CodeArtifact"
  value       = aws_codeartifact_repository.maven.repository
}
