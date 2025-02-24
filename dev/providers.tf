provider "aws" {
  region = var.location
  default_tags {
    tags = {
      ManagedBy = "Terraform"
      Usage     = "SSO"
      Env       = "Development"
    }
  }
}
