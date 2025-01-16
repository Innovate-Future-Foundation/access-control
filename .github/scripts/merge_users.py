import hcl2
import os
import sys


def read_tfvars(file_path: str) -> dict:
    """Read and parse a tfvars file."""
    with open(file_path, 'r') as f:
        return hcl2.load(f)


def write_tfvars(file_path: str, data: dict) -> None:
    """Write data to tfvars file in a formatted way."""
    with open(file_path, 'w') as f:
        f.write('sso_user_map = {\n')
        # Get list of usernames (maintaining order)
        usernames = list(data['sso_user_map'].keys())

        # Iterate through usernames
        for i, username in enumerate(usernames):
            user = data['sso_user_map'][username]
            # Convert group_membership list to use double quotes
            groups = [f'"{group}"' for group in user["group_membership"]]
            group_str = f'[{", ".join(groups)}]'

            f.write(f'  "{username}" = {{\n')
            f.write(f'    group_membership = {group_str}\n')
            f.write(f'    user_name        = "{user["user_name"]}"\n')
            f.write(f'    given_name       = "{user["given_name"]}"\n')
            f.write(f'    family_name      = "{user["family_name"]}"\n')
            f.write(f'    email           = "{user["email"]}"\n')
            # Add comma if not the last item
            if i < len(usernames) - 1:
                f.write('  },\n')
            else:
                f.write('  }\n')
        f.write('}\n')


def validate_user_request(username: str, user_data: dict, existing_users: dict) -> bool:
    """Validate the user request."""
    if username != user_data['user_name']:
        print(
            f"Error: Username mismatch between key '{username}' and user_name '{user_data['user_name']}'")
        return False
    return True


def main():
    # Get changed files from environment variable
    changed_files = os.getenv('CHANGED_FILES', '').split()
    if not changed_files:
        print("No changed files to process")
        return

    # Read main terraform.tfvars
    main_config = read_tfvars('terraform.tfvars')
    existing_users = main_config.get('sso_user_map', {})

    # Track if any changes were made
    changes_made = False

    # Process each changed file
    for file_path in changed_files:
        print(f"Processing: {file_path}")
        request_config = read_tfvars(file_path)

        # Validate and merge each user in the request
        for username, user_data in request_config['sso_user_map'].items():
            if validate_user_request(username, user_data, existing_users):
                if username in existing_users:
                    print(f"Updating user: {username}")
                else:
                    print(f"Adding new user: {username}")

                existing_users[username] = user_data
                changes_made = True
            else:
                print(f"Skipping invalid user request: {username}")
                sys.exit(1)

    if changes_made:
        # Update main config and write back
        main_config['sso_user_map'] = existing_users
        write_tfvars('terraform.tfvars', main_config)
        print("Successfully updated terraform.tfvars")
    else:
        print("No changes were necessary")


if __name__ == '__main__':
    main()
