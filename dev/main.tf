terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.1"
    }
  }

  # Backend Skeleton
  backend "s3" {}
}

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

# Use Identity Center Module
module "aws-iam-identity-center" {
  source  = "aws-ia/iam-identity-center/aws"
  version = "1.0.1"

  # Create desired GROUPS in IAM Identity Center
  sso_groups = {
    PlatformAdmin : {
      group_name        = "PlatformAdmin"
      group_description = "PlatformAdmin IAM Identity Center Group"
    },
    DevOps : {
      group_name        = "DevOps"
      group_description = "DevOps IAM Identity Center Group"
    },
    Developer : {
      group_name        = "Developer"
      group_description = "Dev IAM Identity Center Group"
    },
  }

  # Create desired USERS in IAM Identity Center
  sso_users = {
    "ycwang0037" : {
      group_membership = ["PlatformAdmin"]       # Management Groups
      user_name        = "ycwang0037"            # Unique username, <given-name><surname><4-digit-number>
      given_name       = "Yuechen"               # Your given name
      family_name      = "Wang"                  # Your family name
      email            = "ycyc-doit@outlook.com" # Your working email
    },
    # Add your account details above, assign proper membership and create PR. DO NOT delete this comment
  }

  # Create permissions sets backed by AWS managed policies
  permission_sets = {
    AdministratorAccess = {
      description          = "Provides AWS full access permissions.",
      session_duration     = "PT1H", // how long until session expires - this means 1 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess"]
      tags                 = { ManagedBy = "Terraform" }
    },
    PowerUserAccess = {
      description          = "Provides AWS full access permissions, but does not allow management of Users and groups.",
      session_duration     = "PT2H", // how long until session expires - this means 2 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
      tags                 = { ManagedBy = "Terraform" }
    },
    ReadOnlyAccess = {
      description          = "Provides AWS read only permissions.",
      session_duration     = "PT4H", // how long until session expires - this means 4 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
      tags                 = { ManagedBy = "Terraform" }
    },
  }

  # Assign users/groups access to accounts with the specified permissions
  account_assignments = {
    PlatformAdmin : {
      principal_name  = "PlatformAdmin"         # name of the user or group you wish to have access to the account(s)
      principal_type  = "GROUP"                 # principal type (user or group) you wish to have access to the account(s)
      principal_idp   = "INTERNAL"              # type of Identity Provider you are using. Valid values are "INTERNAL" (using Identity Store) or "EXTERNAL" (using external IdP such as EntraID, Okta, Google, etc.)
      permission_sets = ["AdministratorAccess"] # permissions the user/group will have in the account(s)
      account_ids     = [var.dev_account]       # account(s) the group will have access to. Permissions they will have in account are above line
    },
    DevOps : {
      principal_name  = "DevOps"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = ["PowerUserAccess"]
      account_ids     = [var.dev_account]
    },
    Dev : {
      principal_name  = "Developer"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = ["ReadOnlyAccess"]
      account_ids     = [var.dev_account]
    },
  }

}
