terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
      configuration_aliases = [
        aws.east
      ]
    }
  }

  required_version = ">=1.0"
}