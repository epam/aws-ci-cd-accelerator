
resource "aws_codeartifact_domain" "project_domain" {
  domain = "${var.repo_name}-${var.region_name}"
}

resource "aws_codeartifact_repository" "maven" {
  repository = "maven"
  domain     = aws_codeartifact_domain.project_domain.domain
  external_connections {
    external_connection_name = "public:maven-central"
  }
}