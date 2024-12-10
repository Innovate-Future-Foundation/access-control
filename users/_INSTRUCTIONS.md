# User Access Request Instructions

## Template Structure

Create a new file `users/requests/your-username.json` using this structure:

```json
{
  "your-username": {
    "group_membership": ["Dev"],
    "user_name": "your-username",
    "given_name": "YourFirstName",
    "family_name": "YourLastName",
    "email": "your.email@domain.com"
  }
}
```

## Field Requirements

| Field            | Description                       | Format                                  | Example               |
| ---------------- | --------------------------------- | --------------------------------------- | --------------------- |
| Root Key         | Your username (same as user_name) | `<firstname><lastname><4-digits>`       | `johndoe0001`         |
| group_membership | Access level                      | `["Admin"]`, `["DevOps"]`, or `["Dev"]` | `["Dev"]`             |
| user_name        | Your username                     | Same as root key                        | `johndoe0001`         |
| given_name       | First name                        | As per official documents               | `John`                |
| family_name      | Last name                         | As per official documents               | `Doe`                 |
| email            | Your email address                | Valid email format                      | `john.doe@domain.com` |
