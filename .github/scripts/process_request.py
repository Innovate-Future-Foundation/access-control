import json
import os
import re


def validate_user_info(username, user_info):
    # Validate that root key matches username
    if username != user_info["user_name"]:
        raise ValueError("Root key must match user_name")

    # Validate group membership
    valid_groups = ["Admin", "DevOps", "Dev"]
    if not all(group in valid_groups for group in user_info["group_membership"]):
        raise ValueError("Invalid group membership")

    # Validate username format
    if not re.match(r'^[a-z]+[a-z]+\d{4}$', user_info["user_name"]):
        raise ValueError("Invalid username format")

    # Validate email format (general email validation)
    if not re.match(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$', user_info["email"]):
        raise ValueError("Invalid email format")


def process_request():
    # Read the request file
    request_files = [f for f in os.listdir(
        'users/requests') if f.endswith('.json')]
    if not request_files:
        print("No request files found")
        return

    # Read main.tf
    with open('main.tf', 'r') as f:
        content = f.read()

    # Find the sso_users block start and end
    sso_users_start = content.find('sso_users = {')
    if sso_users_start == -1:
        print("Could not find sso_users block")
        return

    # Find the comment line
    comment = "# Add your account details above, assign proper membership and create PR. DO NOT delete this comment"

    # Extract existing users block
    sso_users_end = content.find('permission_sets', sso_users_start)
    users_block = content[sso_users_start:sso_users_end]

    # Process each request
    for request_file in request_files:
        with open(f'users/requests/{request_file}', 'r') as f:
            request_data = json.load(f)

        username = list(request_data.keys())[0]
        user_info = request_data[username]

        # Validate user info
        validate_user_info(username, user_info)

        # Format new user entry
        new_user = f"""    "{username}" : {{
      group_membership = {json.dumps(user_info["group_membership"])}
      user_name        = "{user_info["user_name"]}"
      given_name       = "{user_info["given_name"]}"
      family_name      = "{user_info["family_name"]}"
      email            = "{user_info["email"]}"
    }}"""

        # Find the position to insert the new user (before the comment)
        comment_pos = users_block.find(comment)
        if comment_pos == -1:
            print("Could not find comment marker")
            return

        # Insert the new user before the comment
        last_brace = users_block.rfind('}', 0, comment_pos)
        if last_brace != -1:
            # Add comma after the last user if it doesn't exist
            if users_block[last_brace + 1:].strip().startswith(comment):
                users_block = users_block[:last_brace + 1] + ',\n' + new_user + '\n    ' + \
                    users_block[users_block.find(comment):]
            else:
                users_block = users_block[:last_brace + 1] + ',\n' + new_user + '\n    ' + \
                    users_block[users_block.find(comment):]

    # Replace the old sso_users block with the updated one
    content = content[:sso_users_start] + users_block + content[sso_users_end:]

    # Write back to main.tf
    with open('main.tf', 'w') as f:
        f.write(content)


if __name__ == "__main__":
    process_request()
