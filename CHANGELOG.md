# Changelog
<hr>

## [v2.0.0] - 2024-05-26

<hr>

### Added

- Implemented Docker image security check with Trivy for the pipeline.
- Added documentation on non-secret variables management during deployment.
- Added AI handler integration with Checkov and TFSec.
- Added AI Handler for Terraform code errors and security checks.
- Added possibilities for AI Handler to work with BitBucket.
- Added possibilities for AI Handler to work with Gitlab.
- Added AWS Canary-Synthetics.
- Added an integration with EPAM CARRIER.
- Added AI Handler capabilities to process Terraform errors.
- Added documentation for all AI features.
- Added versioning for Docker image in the pipeline.
- Implemented code and documentation for deploying infrastructure and applications in ECS and EKS clusters with RDS support.

### Changed

- Changed the official name of the project to InfraPhoenix.
- Updated open source Terraform modules to current versions.
- Documented the deployment process of the new version of Accelerator.

### Fixed

- Added the ability to use secret variables for deployment to an ECS cluster.
- Rewrote Terraform code to use a single DLT test for several pipelines.
- Changed Instance Metadata Service for EC2 instances to Version 2.
- Added AWS WAF integration for DLT.

### Breaking Changes

- Redesigned Terragrunt and Terraform modules to deploy IaC infrastructure across multiple regions and accounts.
  The previous infrastructure must be removed before the deployment of this version!

<hr>
