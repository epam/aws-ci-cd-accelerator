import json
import boto3
import os
import re
import requests

github_token_name = os.getenv('GITHUB_TOKEN_NAME')


def get_parameter_from_ssm(parameter_name):
    ssm = boto3.client('ssm', region_name=os.getenv('AWS_REGION'))  # Change region_name as necessary
    response = ssm.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return response['Parameter']['Value']


# using an access token
access_token = get_parameter_from_ssm(github_token_name)
print(access_token)

# CodeBuild name
codebuild_name = os.getenv("CODEBUILD")


def post_github_comment(owner, repo, pull_request_number, access_token, help_message):
    url = f"https://api.github.com/repos/{owner}/{repo}/issues/{pull_request_number}/comments"
    headers = {
        "Authorization": f"token {access_token}",
        "Content-Type": "application/json"
    }
    data = {
        "body": f"\n {help_message}"
    }
    response = requests.post(url, headers=headers, json=data)
    print("response code:", response)
    return response.json()


def get_source_branch(owner, repo, pull_request_number, access_token):
    url = f"https://api.github.com/repos/{owner}/{repo}/pulls/{pull_request_number}"
    headers = {"Authorization": f"token {access_token}"}

    response = requests.get(url, headers=headers)
    pull_request_data = response.json()
    print(pull_request_data)

    source_branch = pull_request_data["head"]["ref"]

    return source_branch


def add_reaction_to_github_comment(owner, repo, comment_id, access_token, reaction):
    url = f"https://api.github.com/repos/{owner}/{repo}/issues/comments/{comment_id}/reactions"
    headers = {
        "Authorization": f"token {access_token}",
        "Content-Type": "application/json",
        "Accept": "application/vnd.github.squirrel-girl-preview+json"
    }
    data = {
        "content": reaction
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()


def lambda_handler(event, context):
    print(event)
    # Load the entire event body as a JSON dictionary
    body_dict = json.loads(event['body'])
    print(body_dict)
    # Access the 'issue' field within the body dictionary
    issue_data = body_dict['issue']
    pull_request_number = body_dict['issue']['number']
    owner = body_dict["repository"]["owner"]["login"]
    repo = body_dict["repository"]["name"]

    # Access the 'comment' field within the body dictionary
    comment_data = body_dict['comment']

    # Access the 'id' field within the comment data (comment id)
    comment_id = comment_data['id']

    # Access the 'body' field within the comment data (comment content)
    comment_body = comment_data['body']
    if not comment_body.strip().startswith("Available options of AI handler:"):

        pr_found = False
        # Split the `comment_body` by spaces to find " pr "
        for substr in comment_body.split():
            if substr == "pr":
                pr_found = True
                break

        # If a " pr " substring is found, set `pr_create` to 1
        if pr_found:
            pr_create = "1"
        else:
            pr_create = "0"

        help_match = re.search(r"AIRobot (\bhelp\b)", comment_body)
        unit_test_match = re.search(r"AIRobot unit_test ([^\s]+)\s*(pr)?", comment_body)
        doc_match = re.search(r"AIRobot doc ([\S]+)", comment_body)
        comment_match = re.search(r"AIRobot comment ([^\s]+)\s*(pr)?", comment_body)

        if unit_test_match:
            print("Condition met")
            extracted_text = unit_test_match.group(1)
            print("extracted_text unit", extracted_text)
            file_name = extracted_text
            action_type = "unit_test"
        elif doc_match:
            print("Condition met")
            extracted_text = doc_match.group(1)
            print("extracted_text doc", extracted_text)
            file_name = extracted_text
            action_type = "doc"
        elif comment_match:
            print("Condition met")
            extracted_text = comment_match.group(1)
            print("extracted_text comment", extracted_text)
            file_name = extracted_text
            action_type = "comment"
        elif help_match:
            print("Help requested")
            extracted_help = help_match.group(1)
            print("extracted_help:", extracted_help)
            action_type = "help"
            help_message = """Available options of AI handler:\n
:wrench: To receive a unit test for a specific file run:\n
```\n
# By default the result in a Pull Request comment\n
AIRobot unit_test <full path to the file from the root>\n\n
# Add pr option - to receive an output in a new Pull Request\n
AIRobot unit_test <full path to the file from the root> pr\n
```\n
Example:\n
```\n
AIRobot unit_test src/file.py\n
AIRobot unit_test src/file.py pr\n
```\n
:blue_book: To receive a code explanation for a specific file run:\n
```\n
AIRobot doc <full path to the file from the root>\n
```\n
Example:\n
```\n
AIRobot doc src/file.py\n
```\n
:clipboard: To cover a code with additional comments for a specific file run:\n
```\n
# By default the result in a Pull Request comment\n
AIRobot comment <full path to the file from the root>\n\n
# Add pr option - to receive an output in a new Pull Request\n
AIRobot comment <full path to the file from the root> pr\n
```\n
Example:\n
```\n
AIRobot comment src/file.py\n
AIRobot comment src/file.py pr\n
```
"""
            post_github_comment(owner, repo, pull_request_number, access_token, help_message)
        else:
            print("No condition met")
            # Handle the scenario when none of the patterns are found
            return {
                'statusCode': 200
            }

        source_branch = get_source_branch(owner, repo, pull_request_number, access_token)
        print(action_type)
        if action_type in ['doc', 'unit_test', 'comment']:
            codebuild = boto3.client('codebuild')
            response = codebuild.start_build(
                projectName=f"{codebuild_name}",
                environmentVariablesOverride=[
                    {
                        'name': 'PULL_NUM',
                        'value': str(pull_request_number),
                        'type': 'PLAINTEXT'
                    },
                    {
                        'name': 'ACTION_TYPE',
                        'value': str(action_type),
                        'type': 'PLAINTEXT'
                    },
                    {
                        'name': 'SOURCE_BRANCH',
                        'value': str(source_branch),
                        'type': 'PLAINTEXT'
                    },
                    {
                        'name': 'OWNER',
                        'value': str(owner),
                        'type': 'PLAINTEXT'
                    },
                    {
                        'name': 'REPO_NAME',
                        'value': str(repo),
                        'type': 'PLAINTEXT'
                    },
                    {
                        'name': 'FILE_NAME',
                        'value': str(file_name),
                        'type': 'PLAINTEXT'
                    },
                    {
                        'name': 'PR_CREATE',
                        'value': str(pr_create),
                        'type': 'PLAINTEXT'
                    }
                ]
            )
            print(response)

    # Add a reaction to the comment
    reaction = "heart"  # Set an emoji here
    reaction_response = add_reaction_to_github_comment(owner, repo, comment_id, access_token, reaction)
    print(f"Added reaction: {reaction_response['content']}")

    return {
        'statusCode': 200
    }
