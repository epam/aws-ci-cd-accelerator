resource "aws_codeartifact_domain_permissions_policy" "test" {
  domain          = aws_codeartifact_domain.project_domain.domain
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "codeartifact:CreateRepository",
            "Effect": "Allow",
            "Principal": "*",
            "Resource": "${aws_codeartifact_domain.project_domain.arn}"
        }
    ]
}
EOF
}
resource "aws_codeartifact_repository_permissions_policy" "example" {
  repository      = aws_codeartifact_repository.maven.repository
  domain          = aws_codeartifact_domain.project_domain.domain
  policy_document = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "codeartifact:AssociateExternalConnection",
                "codeartifact:CopyPackageVersions",
                "codeartifact:DeletePackageVersions",
                "codeartifact:DeleteRepository",
                "codeartifact:DeleteRepositoryPermissionsPolicy",
                "codeartifact:DescribePackageVersion",
                "codeartifact:DescribeRepository",
                "codeartifact:DisassociateExternalConnection",
                "codeartifact:DisposePackageVersions",
                "codeartifact:GetPackageVersionReadme",
                "codeartifact:GetRepositoryEndpoint",
                "codeartifact:ListPackageVersionAssets",
                "codeartifact:ListPackageVersionDependencies",
                "codeartifact:ListPackageVersions",
                "codeartifact:ListPackages",
                "codeartifact:PublishPackageVersion",
                "codeartifact:PutPackageMetadata",
                "codeartifact:PutRepositoryPermissionsPolicy",
                "codeartifact:ReadFromRepository",
                "codeartifact:UpdatePackageVersionsStatus",
                "codeartifact:UpdateRepository"
            ],
            "Effect": "Allow",
            "Resource": "${aws_codeartifact_repository.maven.arn}",
            "Principal": {
                "AWS": "${var.codebuild_role_arn}"
            }
        }
    ]
}
EOF
}