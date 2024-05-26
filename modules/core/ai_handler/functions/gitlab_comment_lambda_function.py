import os
import requests
import boto3
import json

project_id = os.environ.get('PROJECT_ID', '')
git_token_name = os.environ.get("GIT_TOKEN_NAME", "")

git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://{git_hostname}/api/v4")

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

def add_award_to_note(merge_request_id, note_id, reaction):
    url = f"{git_api}/projects/{project_id}/merge_requests/{merge_request_id}/notes/{note_id}/award_emoji"
    data = {
        "name": reaction
    }
    headers = {'Private-Token': git_token}
    response = requests.post(url, headers=headers, json=data)
    print("Response:", response.status_code, response.text)  # Add this line
    return response.json()

def start_codebuild_project(project_name, merge_request_id, source_branch, user_comment):
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
                'value': str(merge_request_id),
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

def get_merge_request_info(merge_request_id):
    url = f"{git_api}/projects/{project_id}/merge_requests/{merge_request_id}"
    headers = {"PRIVATE-TOKEN": git_token}

    response = requests.get(url, headers=headers)
    return response.json()

def lambda_handler(event, context):
    # Parse the message from the GitHub webhook
    message = json.loads(event['body'])

    print(message)
    try:
        comment_text = message['object_attributes']['note']
        merge_request_id = message['merge_request']['iid']
        note_id = message['object_attributes']['id']
        merge_request_info = get_merge_request_info(merge_request_id)
        source_branch = merge_request_info['source_branch']
    except KeyError:
        print("Webhook event does not contain required fields.")
        return {'statusCode': 400, 'body': 'Bad Request'}

    if comment_text.lower() == 'approved':
        # Process the approval
        start_codebuild_project(project_name=codebuild_name, merge_request_id=merge_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
        # Add a reaction to the comment
        reaction = "eyes"  # Set an emoji here
        add_award_to_note(merge_request_id, note_id, reaction)

    elif comment_text.lower().startswith('user updates:'):
        # Process user updates
        start_codebuild_project(project_name=codebuild_name, merge_request_id=merge_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
        # Add a reaction to the comment
        reaction = "eyes"  # Set an emoji here
        add_award_to_note(merge_request_id, note_id, reaction)

    elif comment_text.lower().startswith('user question:'):
        # Process user updates
        start_codebuild_project(project_name=codebuild_name, merge_request_id=merge_request_id,
                                source_branch=source_branch,
                                user_comment=comment_text)
        # Add a reaction to the comment
        reaction = "thumbsup"  # Set an emoji here
        add_award_to_note(merge_request_id, note_id, reaction)

    else:
        print("Ignoring comment")

    return {'statusCode': 200}
