import os
import requests
import boto3

git_token_name = os.environ.get("GIT_TOKEN_NAME", "")
repo_name = os.environ.get("REPO_NAME", "")
repo_owner = os.environ.get("REPO_OWNER", "")
git_hostname = os.environ.get('GIT_HOSTNAME', '')
project_id = os.environ.get('PROJECT_ID', '')
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

def extract_pr_number(content):
    pattern = f"/home/atlantis/.atlantis/repos/{repo_owner}/{repo_name}/"
    start = content.find(pattern)

    # debug print
    print(f"Start: {start}")

    if start != -1:
        start += len(pattern)
        end = content.find("/", start)

        # debug print
        print(f"End: {end}")

        if end != -1:
            merge_request_id = content[start:end]

            # debug print
            print(f"Extracted PR number: {merge_request_id}")

            if merge_request_id.isdigit():
                return merge_request_id

    print("PR number not found in error string")
    return None

def get_merge_request_info(merge_request_id):
    url = f"{git_api}/projects/{project_id}/merge_requests/{merge_request_id}"
    headers = {"PRIVATE-TOKEN": git_token}

    response = requests.get(url, headers=headers)
    print(f'Response:\n {response}')
    return response.json()

def post_gitlab_comment(merge_request_id, comment):
    url = f"{git_api}/projects/{project_id}/merge_requests/{merge_request_id}/notes"
    data = {
        "body": comment
    }
    headers = {"PRIVATE-TOKEN": git_token}
    response = requests.post(url, json=data, headers=headers)
    print("response code:", response)
    return response.json()

def start_codebuild(merge_request_id, source_branch):
    codebuild = boto3.client('codebuild')
    response = codebuild.start_build(
        projectName=codebuild_name,
        sourceVersion=source_branch,
        environmentVariablesOverride=[
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
    print(response)

def lambda_handler(event, context):
    s3_bucket = event['Records'][0]['s3']['bucket']['name']
    s3_key = event['Records'][0]['s3']['object']['key']

    s3_client = boto3.client('s3')

    response = s3_client.get_object(Bucket=s3_bucket, Key=s3_key)
    content = response['Body'].read().decode()
    print(f'Content: {content}')

    merge_request_id = extract_pr_number(content)
    print(f"MR number: {merge_request_id}")

    merge_request_info = get_merge_request_info(merge_request_id)
    print(f'Merge request info: {merge_request_info}')
    source_branch = merge_request_info['source_branch']
    print(f'source_branch: {source_branch}')
    start_codebuild(merge_request_id=merge_request_id, source_branch=source_branch)

    comment = "AI_ROBOT_START: Start AI Analysing. **Look carefully at AI answer**. Wait a minute..."
    post_gitlab_comment(merge_request_id=merge_request_id, comment=comment)
