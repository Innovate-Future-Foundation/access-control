# AWS IAM Identity Center Access Management

This repository manages AWS SSO access through IAM Identity Center using Terraform. It provides automated user access management for different AWS accounts with predefined permission sets.

## 🎯 Access Levels & Permissions

We have three access levels:

| Group  | Permission Set      | Session Duration | Description                          |
| ------ | ------------------- | ---------------- | ------------------------------------ |
| Admin  | AdministratorAccess | 1 hour           | Full AWS access                      |
| DevOps | PowerUserAccess     | 2 hours          | Full access except IAM/Organizations |
| Dev    | ReadOnlyAccess      | 4 hours          | Read-only access to all resources    |

## 🚀 How to Request Access

### Step 1: Fork & Clone

1. Fork this repository
2. Clone your forked repository:

```bash
git clone https://github.com/your-username/access-control.git
cd access-control
```

### Step 2: Create Access Request

1. Read the documentation:

   - Review `users/_INSTRUCTIONS.md` for detailed requirements
   - Check `users/_template.json` for the required format

2. Create a new branch:

```bash
git checkout -b access/your-username
```

3. Copy the template and create your request:

```bash
# Copy the template
cp users/_template.json users/requests/your-username.json
```

4. Edit your request file (`users/requests/your-username.json`) with your information:

```json
{
  "ycwang0037": {
    "group_membership": ["DevOps"],
    "user_name": "ycwang0037",
    "given_name": "Yuechen",
    "family_name": "Wang",
    "email": "ycyc-doit@outlook.com"
  }
}
```

### Step 3: Submit PR

1. Commit your changes:

```bash
git add users/requests/your-username.json
git commit -m "feat(access): Add access request for <your-name>"
git push origin access/your-username
```

2. Create a Pull Request on GitHub

### What Happens Next?

1. Our automation will:
   - Validate your request format and information
   - Check that your username matches in all places
   - Add your user to the main configuration
   - Update the PR with the changes
2. The DevOps team will review your request
3. Once approved, you'll receive an email invitation

## 📋 Username Convention

- Format: `<firstname><lastname><4-digits>`
- Example: `johnsmith0001`
- All lowercase, no special characters
- 4-digit number should be unique
- Must be identical in:
  - JSON file name
  - Root key of JSON
  - user_name field

## ⚡ After Access is Granted

1. You'll receive an email invitation to AWS IAM Identity Center
2. Follow the email instructions to set up your credentials
3. Access AWS Console: https://[your-org].awsapps.com/start

## 🔑 AWS CLI Access

1. Install AWS CLI v2
2. Configure SSO:

```bash
aws configure sso
SSO Start URL [None]: https://[your-org].awsapps.com/start
SSO Region [None]: us-east-1
```

3. Follow the browser prompts to authenticate

## 📁 Repository Structure

```
.
├── main.tf                    # Main Terraform configuration
├── variables.tf               # Terraform variables
├── users/
│   ├── README.md             # Directory documentation
│   ├── _template.json        # Clean template for new users
│   ├── _INSTRUCTIONS.md      # Detailed instructions
│   └── requests/             # User requests directory
│       └── .gitkeep         # Keeps the empty directory in git
├── .github/
│   ├── workflows/            # GitHub Actions workflows
│   └── scripts/              # Processing scripts
└── README.md                 # This file
```
