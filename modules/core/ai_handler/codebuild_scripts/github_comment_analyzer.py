import json
import os
import requests
from git import Repo
import re
import logging
from openai import OpenAI

api_key = os.environ.get('OPENAI_TOKEN', '')
llm_model = os.environ.get("LLM_MODEL", "gpt-3.5-turbo-instruct")
git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://api.{git_hostname}")
github_token = os.environ.get("GIT_TOKEN", "")
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
            file.write(f"{fix}\n")

    print(os.getcwd())
    print(repo.git.status())

    # Add and commit the changes
    repo.git.config('--local', 'user.name', 'AI Robot')
    repo.git.config('--local', 'user.email', 'open_ai@example.com')
    repo.git.add(A=True)  # adds all changed files to the commit
    repo.git.commit('-m', 'Committed the AI code fixes')  # commits the changes with a message
    repo.git.push()

def generate_fix(user_comment):
    client = OpenAI(api_key=api_key)

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
    prompt = (f'''Look at Errors:\n {error_content}\n
        Fix file using User proposition:\n {user_comment}\n
        {file_path}\n{open(f'{repo_path}/{file_path}').read()}\n
        Don't change any other parts of the content!!! \n
        IMPORTANT!!! Return the full fixed file content!!!''')
    system_message = {"role": "system", "content": "You are a helpful assistant."}
    user_message = {"role": "user", "content": prompt}

    response = client.chat.completions.create(
        model=llm_model,
        messages=[
            system_message,
            user_message
        ],
        max_tokens=1700,
        temperature=0.5,
    )
    if response is not None:

        fix = response.choices[0].message.content.strip()
        fix = fix.replace("```hcl\n", "").replace("\n```", "")
        # Add file_path as a key and fix as the corresponding value to the dictionary
        generated_fix[file_path] = fix

        print(generated_fix)

    else:
        print('Failed to communicate with AI.')
        return None

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


def handle_feedback(user_comment):
    client = OpenAI(api_key=api_key)

    prompt = user_comment
    system_message = {"role": "system", "content": "You are a helpful assistant."}
    user_message = {"role": "user", "content": prompt}

    response = client.chat.completions.create(
        model=llm_model,
        messages=[
            system_message,
            user_message
        ],
        max_tokens=1700,
        temperature=0.5,
    )
    if response is not None:

        generated_feedback = response.choices[0].message.content.strip()
    else:
        print('Failed to communicate with AI.')
        return None

    return generated_feedback

def post_comment_to_pr(comment_text):
    comments_url = f"{git_api}/repos/{repo_owner}/{repo_name}/issues/{pull_request_number}/comments"
    logging.info(f"Posting comment to URL: {comments_url}")

    headers = {'Authorization': f'token {github_token}'}
    comment_data = {
        "body": comment_text,
    }

    response = requests.post(comments_url, headers=headers, json=comment_data)

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
        generated_feedback = handle_feedback(user_comment)
        post_comment_to_pr(comment_text=generated_feedback)
        print(generated_feedback)

    elif user_comment.lower().startswith('user updates:'):
        # Process feedback use case
        user_comment = user_comment.split(":")[1].strip()
        generated_fix = generate_fix(user_comment)
        updated_fix_text = update_error_fix_log(generated_fix)
        print(f'updated_fix_text:\n {updated_fix_text}')
        fixed_text = "\n".join(
            [f"File: {file_path}\n```hcl\n{fix}\n```\n" for file_path, fix in updated_fix_text.items()])
        post_comment_to_pr(comment_text=fixed_text)
    else:
        print('Ignoring comment')

if __name__ == "__main__":
    main()
