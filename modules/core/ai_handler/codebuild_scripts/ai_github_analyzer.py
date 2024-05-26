import json
import os
import requests
import re
import logging
from openai import OpenAI

api_key = os.environ.get('OPENAI_TOKEN', '')
llm_model = os.environ.get("LLM_MODEL", "gpt-3.5-turbo")
git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://api.{git_hostname}")

github_token = os.environ.get("GIT_TOKEN", "")

# Environment variables for repository & pull request information
repo_name = os.environ.get('REPO_NAME', '')
repo_owner = os.environ.get('REPO_OWNER', '')
pull_request_number = os.environ.get('PULL_NUM', '')
source_branch = os.environ.get('SOURCE_BRANCH', '')

repo_path = os.environ.get('CODEBUILD_SRC_DIR', '')

def process_log_and_extract_errors(error_log):
    prefix_pattern = r'level=\w+ msg=Terraform invocation failed in (.+\.terragrunt-cache[^\s]+)'
    error_pattern = r'(Error:(?:.|\n)+?)(?=Error:|$)'
    file_pattern = r'on (\S+\.tf)? ?line \d+.*\n *\d+: *'
    module_pattern = re.compile(r"modules/(.*)")
    prefix_matches = re.findall(prefix_pattern, error_log)
    error_matches = re.findall(error_pattern, error_log, flags=re.DOTALL)

    extracted_errors = []

    terrugrunt_prefix = ''
    if prefix_matches:
        terrugrunt_prefix = prefix_matches[0]

    for error in error_matches:
        error = error.strip()
        file_match = re.search(file_pattern, error)
        file_name = file_match.group(1) if file_match else None
        terraform_full_path = terrugrunt_prefix.rstrip()
        module_match = module_pattern.search(terraform_full_path)
        if module_match:
            module_path = f"modules/{module_match.group(1)}"
            file_path = f'{module_path}/{file_name}'
            extracted_errors.append([file_path, error])
        else:
            print ("There is an error in the input file format")
            exit(1)
    return extracted_errors

def generate_fix(extracted_errors):
    client = OpenAI(api_key=api_key)

    fixes = {}
    test_file_path = ""
    for file_path, error in extracted_errors:
        if file_path != test_file_path:
            print(f'error: {error}')
            prompt = (f'''Look at Errors: {error}\n
            Fix the error and change only the lines with errors in original file!\n
            {file_path}\n{open(f'{repo_path}/{file_path}').read()}\n\n
            IMPORTANT!!! Don't change any other part of code! Print the full file's content!!!''')

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

                generated_fix = response.choices[0].message.content.strip()
                generated_fix = generated_fix.replace("```hcl\n", "").replace("\n```", "")
                fixes[file_path] = generated_fix
            else:
                print('Failed to communicate with AI.')
                return None
        else:
            continue
        test_file_path = file_path

    with open('/tmp/error_fix.log', 'w') as file:
        json.dump(fixes, file)

    return fixes

def post_comment_to_pr(comment_text):
    comments_url = f"{git_api}/repos/{repo_owner}/{repo_name}/issues/{pull_request_number}/comments"
    logging.info(f"Posting comment to URL: {comments_url}")

    comment_data = {
        "body": comment_text,
    }

    headers = {'Authorization': f'token {github_token}'}

    response = requests.post(comments_url, headers=headers, json=comment_data)

    if response.status_code == 201:
        logging.info(f"Successfully posted comment to pull request #{pull_request_number}")
    else:
        logging.error(f"Failed to post comment. Response code: {response.status_code}, response text: {response.text}")
        response.raise_for_status()

def main():
    logging.info("Starting main function.")

    with open('/tmp/error.log') as file:
        error_log = file.read()
        file.close()
    extracted_errors = process_log_and_extract_errors(error_log)
    try:
        with open('/tmp/extracted_errors.log', 'w') as file:
            for file_path, error_line in extracted_errors:
                file.write(f'{file_path}\n{error_line} \n\n')
                print({file_path})
    except Exception as e:
        logging.error(f"Exception while writing to the file: {e}")
    fixes = generate_fix(extracted_errors)

    error_fix_text = "\n".join([f"File: {file_path}\n```hcl\n{fix}\n```\n" for file_path, fix in fixes.items()])

    print(fixes)
    post_comment_to_pr(comment_text=error_fix_text)

if __name__ == "__main__":
    main()
