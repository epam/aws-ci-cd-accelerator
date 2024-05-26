import json
import os
import requests
from git import Repo
import re
from requests.auth import HTTPBasicAuth
import logging

# OpenAI and Bitbucket constants
api_endpoint = os.environ.get("OPENAI_API_ENDPOINT", "https://api.openai.com/v1/completions")
api_key = os.environ.get('OPENAI_TOKEN', '')
llm_model = os.environ.get("LLM_MODEL", "gpt-3.5-turbo-instruct")
git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://api.{git_hostname}/2.0")
bitbucket_user = os.environ.get("GIT_USER", "")
bitbucket_password = os.environ.get("GIT_TOKEN", "")
auth = HTTPBasicAuth(bitbucket_user, bitbucket_password)

# Environment variables for repository & pull request information
repo_name = os.environ.get('REPO_NAME', '')
repo_owner = os.environ.get('REPO_OWNER', '')
pull_request_number = os.environ.get('PULL_NUM', '')
source_branch = os.environ.get('SOURCE_BRANCH', '')

repo_path = os.environ.get('CODEBUILD_SRC_DIR', '')
repo = Repo(repo_path)  # Assuming local repository is available


def read_error_file_content():
    with open('/tmp/extracted_errors.log', 'r') as f:
        error_content = f.read()
        f.close()
    return error_content

def read_fixed_file_content():
    with open('/tmp/error_fix.log', 'r') as file:
        fixed_content = file.read()
        file.close()
    return fixed_content

def commit_fix():
    with open('/tmp/error_fix.log', 'r') as file:
        fixed_content = json.load(file)
    for file_path, fix in fixed_content.items():
        with open(f'{repo_path}/{file_path}', 'w') as file:
            file.write(fix)

    print(os.getcwd())
    print(repo.git.status())

    # Add and commit the changes
    repo.git.config('--local', 'user.name', 'AI Robot')
    repo.git.config('--local', 'user.email', 'open_ai@example.com')
    repo.git.add(A=True)  # adds all changed files to the commit
    repo.git.commit('-m', 'Committed the AI code fixes')  # commits the changes with a message
    repo.git.push()

def generate_fix(api_endpoint, api_key, user_comment):
    generated_fix = {}
    # Get the filepath from the user_comment
    user_comment = user_comment.replace('\\', '')
    file_path = user_comment.split("\n")[0].strip()
    print(f'file_path from comment: {file_path}')
    request_headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }

    error_content = read_error_file_content()
    prompt_text = (f'''Look at Errors:\n {error_content}\n
        Fix file using User proposition:\n {user_comment}\n
        {file_path}\n{open(f'{repo_path}/{file_path}').read()}\n
        Don't change any other parts of the content!\n
        Return full fixed file content!!!''')
    request_data = {
        "model": llm_model,
        "prompt": prompt_text,
        "max_tokens": 1500,
        "temperature": 0.5
    }

    response = requests.post(api_endpoint, headers=request_headers, json=request_data)
    if response.status_code == 200:
        logging.info(f"OpenAI request: {response.text}")

        fix = response.json()["choices"][0]["text"].strip()

        # Add file_path as a key and fix as the corresponding value to the dictionary
        generated_fix[file_path] = fix

        print(generated_fix)
        logging.info(f"Generated fix for:\n {generated_fix}")

    else:
        logging.error(
            f"OpenAI request failed with status code: {response.status_code}")

    return generated_fix

def update_error_fix_log(generated_fix):
    # Read current fixes
    with open('/tmp/error_fix.log', 'r') as file:
        current_fixes = json.load(file)

    # Add new fix
    for file_path, fix in generated_fix.items():
        current_fixes[file_path] = fix

    # Write updated dictionary back to file
    with open('/tmp/error_fix.log', 'w') as file:
        json.dump(current_fixes, file)

    return current_fixes

def handle_feedback(api_endpoint, api_key, user_comment):
    request_headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {api_key}"
    }

    prompt_text = user_comment
    request_data = {
        "model": llm_model,
        "prompt": prompt_text,
        "max_tokens": 1700,
        "temperature": 0.5
    }
    generated_feedback = ''
    response = requests.post(api_endpoint, headers=request_headers, json=request_data)
    if response.status_code == 200:
        logging.info(f"OpenAI request: {response.text}")

        generated_feedback = response.json()["choices"][0]["text"].strip()
        logging.info(f"Generated feedback: {generated_feedback}")

    else:
        logging.error({response.status_code})

    return generated_feedback

def post_comment_to_pr(repo_owner, repo_name, pull_request_number, comment_text):
    comments_url = f"{git_api}/repositories/{repo_owner}/{repo_name}/pullrequests/{pull_request_number}/comments"
    logging.info(f"Posting comment to URL: {comments_url}")

    comment_data = {
        "content": {
            "raw": comment_text,
        }
    }

    response = requests.post(comments_url, auth=auth, json=comment_data)

    if response.status_code == 201:
        logging.info(f"Successfully posted comment to pull request #{pull_request_number}")
    else:
        logging.error(f"Failed to post comment. Response code: {response.status_code}, response text: {response.text}")
        response.raise_for_status()


def main():
    user_comment = os.environ.get("USER_COMMENT", "")

    if user_comment.lower() == 'approved':
        # Process the approval
        commit_fix()

    elif user_comment.lower().startswith('user question:'):
        user_comment = user_comment.split(":")[1].strip()
        generated_feedback = handle_feedback(api_endpoint, api_key, user_comment)
        post_comment_to_pr(repo_owner=repo_owner, repo_name=repo_name,
                                     pull_request_number=pull_request_number,
                                     comment_text=generated_feedback)
        print(generated_feedback)

    elif user_comment.lower().startswith('user updates:'):
        # Process feedback use case
        user_comment = user_comment.split(":")[1].strip()
        generated_fix = generate_fix(api_endpoint, api_key, user_comment)
        updated_fix_text = update_error_fix_log(generated_fix)
        print(f'updated_fix_text:\n {updated_fix_text}')
        fixed_text = "\n".join(
            [f"File: {file_path}\n\n```hcl\n{fix}\n```\n" for file_path, fix in updated_fix_text.items()])
        post_comment_to_pr(repo_owner=repo_owner, repo_name=repo_name,
                                     pull_request_number=pull_request_number,
                                     comment_text=fixed_text)
    else:
        print('Ignoring comment')

if __name__ == "__main__":
    main()
