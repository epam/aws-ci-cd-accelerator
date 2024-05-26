terraform {
  required_version = ">= 1.0"

  required_providers {

    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.4.0"
    }
  }
}
