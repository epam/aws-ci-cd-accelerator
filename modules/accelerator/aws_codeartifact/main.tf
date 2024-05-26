#======================= Settings for CodeArtifact =======================#
resource "aws_codeartifact_domain" "project_domain" {
  domain = var.project
}

resource "aws_codeartifact_repository" "maven" {
  repository = var.repo_name
  domain     = aws_codeartifact_domain.project_domain.domain
  external_connections {
    external_connection_name = "public:maven-central"
  }
}
