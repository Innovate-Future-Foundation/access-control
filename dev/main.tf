# Use Identity Center Module
module "aws-iam-identity-center" {
  source  = "aws-ia/iam-identity-center/aws"
  version = "1.0.1"

  # Create desired GROUPS in IAM Identity Center
  sso_groups = {
    PlatformAdmin = {
      group_name        = "PlatformAdmin"
      group_description = "PlatformAdmin IAM Identity Center Group"
    },
    DevOps = {
      group_name        = "DevOps"
      group_description = "DevOps IAM Identity Center Group"
    },
    Developer = {
      group_name        = "Developer"
      group_description = "Dev IAM Identity Center Group"
    },
  }

  # Create desired USERS in IAM Identity Center
  sso_users = {
    ycwang0037 = {
      group_membership = ["PlatformAdmin"]   # Management Groups
      user_name        = "ycwang0037"        # Unique username, <given-name><surname><4-digit-number>
      given_name       = "Yuechen"           # Your given name
      family_name      = "Wang"              # Your family name
      email            = "swyc168@gmail.com" # Your working email
    },
    fanwang0207 = {
      group_membership = ["DevOps"]
      user_name        = "fanwang0207"
      given_name       = "Fan"
      family_name      = "Wang"
      email            = "fanwangcareer@gmail.com"
    },
    henrychien1010 = {
      group_membership = ["DevOps"]
      user_name        = "henrychien1010"
      given_name       = "YuCheng"
      family_name      = "Chien"
      email            = "henrychienau@gmail.com"
    },
    qianyang5059 = {
      group_membership = ["Developer"]
      user_name        = "qianyang5059"
      given_name       = "Qingyan"
      family_name      = "Yang"
      email            = "chelsea.yang.work@gmail.com"
    },
    fanzhang8888 = {
      group_membership = ["Developer"]
      user_name        = "fanzhang8888"
      given_name       = "Fan"
      family_name      = "Zhang"
      email            = "zhangfanfansz@gmail.com"
    },
    maxh0085 = {
      group_membership = ["DevOps"]
      user_name        = "maxh0085"
      given_name       = "Mark"
      family_name      = "Ma"
      email            = "mark.xianghui.ma@gmail.com"
    },
    dylan8686 = {
      group_membership = ["DevOps"]
      user_name        = "dylan8686"
      given_name       = "Dylan"
      family_name      = "Song"
      email            = "dylan.song.au@gmail.com"
    },
    jasonw0030 = {
      group_membership = ["DevOps"]
      user_name        = "jasonw0030"
      given_name       = "Jason"
      family_name      = "Wang"
      email            = "wangzj0703@gmail.com"
    },
    # Add your account details above, assign proper membership and create PR. DO NOT delete this comment
  }

  # Create permissions sets backed by AWS managed policies
  permission_sets = {
    Billing = {
      description          = "Provides AWS full access permissions.",
      session_duration     = "PT4H", // how long until session expires - this means 1 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/job-function/Billing"]
    },
    Administrator = {
      description          = "Provides AWS full access permissions.",
      session_duration     = "PT1H", // how long until session expires - this means 1 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/AdministratorAccess", "arn:aws:iam::aws:policy/job-function/Billing"]
    },
    PowerUser = {
      description          = "Provides AWS full access permissions, but does not allow management of Users and groups.",
      session_duration     = "PT2H", // how long until session expires - this means 2 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/PowerUserAccess"]
    },
    ReadOnly = {
      description          = "Provides AWS read only permissions.",
      session_duration     = "PT4H", // how long until session expires - this means 4 hours. max is 12 hours
      aws_managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
    },
  }

  # Assign users/groups access to accounts with the specified permissions
  account_assignments = {
    PlatformAdmin = {
      principal_name  = "PlatformAdmin"              # name of the user or group you wish to have access to the account(s)
      principal_type  = "GROUP"                      # principal type (user or group) you wish to have access to the account(s)
      principal_idp   = "INTERNAL"                   # type of Identity Provider you are using. Valid values are "INTERNAL" (using Identity Store) or "EXTERNAL" (using external IdP such as EntraID, Okta, Google, etc.)
      permission_sets = ["Administrator", "Billing"] # permissions the user/group will have in the account(s)
      account_ids     = [var.dev_account_id]         # account(s) the group will have access to. Permissions they will have in account are above line
    },
    DevOps = {
      principal_name  = "DevOps"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = ["Administrator", "PowerUser"]
      account_ids     = [var.dev_account_id]
    },
    Dev = {
      principal_name  = "Developer"
      principal_type  = "GROUP"
      principal_idp   = "INTERNAL"
      permission_sets = ["ReadOnly"]
      account_ids     = [var.dev_account_id]
    },
  }
}
