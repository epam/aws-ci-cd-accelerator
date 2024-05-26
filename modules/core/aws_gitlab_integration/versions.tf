terraform {
  required_version = ">= 1.0"
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = "3.20.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">= 4.0.5"
    }
  }
}
