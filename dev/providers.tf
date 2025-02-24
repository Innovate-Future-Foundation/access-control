provider "aws" {
  region = var.location
  default_tags {
    tags = local.general_tags
  }
}

locals {
  general_tags = {
    ManagedBy = "Terraform"
    Usage     = "SSO"
    Env       = "Development"
  }
}
