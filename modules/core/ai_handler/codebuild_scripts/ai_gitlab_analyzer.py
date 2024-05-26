import json
import os
import requests
import re
import logging

# OpenAI and Bitbucket constants
ai_api_endpoint = os.environ.get("OPENAI_API_ENDPOINT", "https://api.openai.com/v1/completions")
ai_api_key = os.environ.get('OPENAI_TOKEN', "")
llm_model = os.environ.get("LLM_MODEL", "gpt-3.5-turbo-instruct")

git_token = os.environ.get("GIT_TOKEN", "")

# Environment variables for repository & merge request information
project_id = os.environ.get('PROJECT_ID', '')
merge_request_id = os.environ.get('PULL_NUM', '')
source_branch = os.environ.get('SOURCE_BRANCH', '')
git_hostname = os.environ.get('GIT_HOSTNAME', '')
git_api = os.environ.get("GIT_API", f"https://{git_hostname}/api/v4")
repo_name = os.environ.get('REPO_NAME', '')

repo_path = f"{os.environ.get('CODEBUILD_SRC_DIR', '')}/{repo_name}"

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
        module_path = f"modules/{module_match.group(1)}"
        file_path = f'{module_path}/{file_name}'

        extracted_errors.append([file_path, error])

    return extracted_errors

def generate_fix(extracted_errors):
    request_headers = {
        "Content-Type": "application/json",
        "Authorization": f"Bearer {ai_api_key}"
    }

    fixes = {}
    test_file_path = ""
    for file_path, error in extracted_errors:
        if file_path != test_file_path:
            print(f'error: {error}')
            prompt_text = (f'''Look at Errors: {error}\n
            Fix the error and change only the lines with errors in original file!\n
            {file_path}\n{open(f'{repo_path}/{file_path}').read()}\n
            Don't change any other part of code, only line with error!\n
            Return full fixed file content!''')
            request_data = {
                "model": llm_model,
                "prompt": prompt_text,
                "max_tokens": 1500,
                "temperature": 0.5
            }

            response = requests.post(ai_api_endpoint, headers=request_headers, json=request_data)
            if response.status_code == 200:
                logging.info(f"OpenAI request: {response.text}")

                generated_fix = response.json()["choices"][0]["text"].strip()
                logging.info(f"Generated fix for {file_path}: {generated_fix}")

                fixes[file_path] = generated_fix
            else:
                logging.error(
                    f"Fix could not be generated for {file_path}. OpenAI request failed with status code: {response.status_code}")
        else:
            continue
        test_file_path = file_path

    with open('/tmp/error_fix.log', 'w') as file:
        json.dump(fixes, file)

    return fixes


def post_comment_to_mr(comment_text):
    comments_url = f"{git_api}/projects/{project_id}/merge_requests/{merge_request_id}/notes"
    logging.info(f"Posting comment to URL: {comments_url}")

    comment_data = {
        "body": comment_text,
    }

    headers = {"PRIVATE-TOKEN": git_token}

    response = requests.post(comments_url, headers=headers, json=comment_data)

    if response.status_code == 201:
        logging.info(f"Successfully posted comment to merge request #{merge_request_id}")
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

    error_fix_text = "\n".join([f"File: {file_path}\n\n```hcl\n{fix}\n```\n" for file_path, fix in fixes.items()])

    print(fixes)
    post_comment_to_mr(error_fix_text)

if __name__ == "__main__":
    main()
