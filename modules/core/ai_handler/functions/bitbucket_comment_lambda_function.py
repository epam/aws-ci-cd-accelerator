from requests.auth import HTTPBasicAuth
import os
import requests
import boto3
import json

git_user = os.environ.get("GIT_USER", "")
git_token_name = os.environ.get("GIT_TOKEN_NAME", "")
repo_name = os.environ.get("REPO_NAME", "")
repo_owner = os.environ.get("REPO_OWNER", "")
git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://api.{git_hostname}/2.0")


def get_parameter_from_ssm(parameter_name):
    ssm = boto3.client('ssm', region_name=os.getenv('AWS_REGION'))  # Change region_name as necessary
    response = ssm.get_parameter(
        Name=parameter_name,
        WithDecryption=True
    )
    return response['Parameter']['Value']


git_token = get_parameter_from_ssm(git_token_name)
auth = HTTPBasicAuth(git_user, git_token)

# CodeBuild name
codebuild_name = os.getenv("CODEBUILD_NAME")


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


def post_bitbucket_comment(pull_request_id, comment):
    url = f"{git_api}/repositories/{repo_owner}/{repo_name}/pullrequests/{pull_request_id}/comments"
    data = {
        "content": {
            "raw": comment
        }
    }
    response = requests.post(url, auth=auth, json=data)
    print("response code:", response)
    return response.json()


def lambda_handler(event, context):
    # Parse the message from the Bitbucket webhook
    message = json.loads(event['body'])
    print(message)
    try:
        comment_text = message['comment']['content']['raw']
        pull_request_id = message['pullrequest']['id']
        source_branch = message['pullrequest']['source']['branch']['name']
    except KeyError:
        print("Webhook event does not contain required fields.")
        return {'statusCode': 400, 'body': 'Bad Request'}

    if comment_text.lower() == 'approved':
        # Process the approval
        start_codebuild_project(project_name=codebuild_name, pull_request_id=pull_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
    elif comment_text.lower().startswith('user updates:'):
        # Process user updates
        start_codebuild_project(project_name=codebuild_name, pull_request_id=pull_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
    elif comment_text.lower().startswith('user question:'):
        # Process user updates
        start_codebuild_project(project_name=codebuild_name, pull_request_id=pull_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)

    else:
        print("Ignoring comment")
    return {'statusCode': 200}
