import os
import requests
import boto3
import json

git_user = os.environ.get("GIT_USER", "")
git_token_name = os.environ.get("GIT_TOKEN_NAME", "")
repo_name = os.environ.get("REPO_NAME", "")
repo_owner = os.environ.get("REPO_OWNER", "")
git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://api.{git_hostname}")

def get_parameter_from_ssm(parameter_name):
    ssm = boto3.client('ssm', region_name=os.getenv('AWS_REGION'))  # Change region_name as necessary
    response = ssm.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return response['Parameter']['Value']

git_token = get_parameter_from_ssm(git_token_name)

# CodeBuild name
codebuild_name = os.getenv("CODEBUILD_NAME")

def add_reaction_to_github_comment(comment_id, reaction):
    url = f"{git_api}/repos/{repo_owner}/{repo_name}/issues/comments/{comment_id}/reactions"
    headers = {
        "Authorization": f"token {git_token}",
        "Content-Type": "application/json",
        "Accept": "application/vnd.github.squirrel-girl-preview+json"
    }
    data = {
        "content": reaction
    }
    response = requests.post(url, headers=headers, json=data)
    return response.json()

def start_codebuild_project(project_name, pull_request_id, source_branch, user_comment):
    codebuild_client = boto3.client('codebuild')
    response = codebuild_client.start_build(
        projectName=project_name,
        sourceVersion=source_branch,
        environmentVariablesOverride=[
            {
                'name': 'USER_COMMENT',
                'value': user_comment,
                'type': 'PLAINTEXT'
            },
            {
                'name': 'PULL_NUM',
                'value': str(pull_request_id),
                'type': 'PLAINTEXT'
            },
            {
                'name': 'SOURCE_BRANCH',
                'value': str(source_branch),
                'type': 'PLAINTEXT'
            },
        ]
    )

    if response['ResponseMetadata']['HTTPStatusCode'] == 200:
        print(f'Successfully started build {project_name}.')
    else:
        print(f'Error starting build {project_name}.')


def get_pull_request_info(pull_request_id):
    url = f"{git_api}/repos/{repo_owner}/{repo_name}/pulls/{pull_request_id}"
    headers = {'Authorization': f'token {git_token}'}

    response = requests.get(url, headers=headers)
    return response.json()

def lambda_handler(event, context):
    # Parse the message from the GitHub webhook
    message = json.loads(event['body'])

    print(message)
    try:
        comment_text = message['comment']['body']
        pull_request_id = message['issue']['number']
        comment_id = message['comment']['id']
        pull_request_info = get_pull_request_info(pull_request_id)
        source_branch = pull_request_info['head']['ref']
    except KeyError:
        print("Webhook event does not contain required fields.")
        return {'statusCode': 400, 'body': 'Bad Request'}

    if comment_text.lower() == 'approved':
        # Process the approval
        start_codebuild_project(project_name=codebuild_name, pull_request_id=pull_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
        # Add a reaction to the comment
        reaction = "rocket"  # Set an emoji here
        add_reaction_to_github_comment(comment_id=comment_id, reaction=reaction)

    elif comment_text.lower().startswith('user updates:'):
        # Process user updates
        start_codebuild_project(project_name=codebuild_name, pull_request_id=pull_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
        # Add a reaction to the comment
        reaction = "eyes"  # Set an emoji here
        add_reaction_to_github_comment(comment_id=comment_id, reaction=reaction)

    elif comment_text.lower().startswith('user question:'):
        # Process user updates
        start_codebuild_project(project_name=codebuild_name, pull_request_id=pull_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
        # Add a reaction to the comment
        reaction = "eyes"  # Set an emoji here
        add_reaction_to_github_comment(comment_id=comment_id, reaction=reaction)

    else:
        print("Ignoring comment")

    return {'statusCode': 200}
