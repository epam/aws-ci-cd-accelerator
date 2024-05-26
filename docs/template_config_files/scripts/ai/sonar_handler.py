import os
import requests
import base64
from collections import defaultdict
from git import Repo

# Update variables and retrieve environment values
project_key = os.getenv("PROJECT_KEY")
pull_request_number = os.getenv("PULL_NUM")
source_branch = os.getenv("CODEBUILD_WEBHOOK_HEAD_REF")
source_branch = source_branch.split('/')[-1]  # Remove 'refs/heads/' prefix from the source_branch
repo_name = os.getenv("REPO_NAME")
organization = os.getenv("ORGANIZATION")
sonar_parameter_value = os.getenv("SONAR_TOKEN")
sonar_url = os.environ.get('SONAR_URL', "https://sonarcloud.io")
api_endpoint = os.environ.get('OPENAI_API_ENDPOINT', "https://api.openai.com/v1/completions")
ai_parameter_value = os.getenv("OPENAI_TOKEN")
github_token_value = os.getenv("GITHUB_TOKEN")
llm_model = os.environ.get('LLM_MODEL', "text-davinci-003")

# since local git repo can be used by https or token authorization we consider both options to get a proper branch name
def update_remote_url_with_token(repo_path, github_token):
    repo = Repo(repo_path)
    remote_url = repo.remotes.origin.url
    new_url = remote_url.replace("https://", f"https://{github_token}@")
    repo.remotes.origin.set_url(new_url)

# Leave a comment in GitHub PR comment window
def post_github_comment(organization, repo_name, pull_request_number, github_token_value, comment, file_path=None):
    url = f"https://api.github.com/repos/{organization}/{repo_name}/issues/{pull_request_number}/comments"
    headers = {
        "Authorization": f"token {github_token_value}",
        "Content-Type": "application/json"
    }

    if file_path:
        data = {
            "body": f"{file_path}\n```\n {comment}"
        }
    else:
        data = {
            "body": f"{comment}"
        }

    response = requests.post(url, headers=headers, json=data)
    return response.json()


# Send a request to AI
def communicate_with_ai(api_endpoint, api_key, file_content, file_name, issues):
    request_headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + api_key
    }
    request_data = {
        "model": f"{llm_model}",
        "prompt": f"Please fix SonarQube issues for this file: {file_name}\nContent: {file_content} \n It has such issues: {', '.join(issues)}. I need code only. No text!",
        "max_tokens": 1500,
        "temperature": 0.7
    }

    response = requests.post(api_endpoint, headers=request_headers, json=request_data)

    if response.status_code == 200:
        error_fix = response.json()["choices"][0]["text"]
        return error_fix.strip()
    else:
        return None

def check_local_branch_exists(repo_path, branch_name):
    found = False
    repo = Repo(repo_path)
    for branch in repo.branches:
        if branch.name == branch_name:
            found = True
            break
    return found


# Create a new branch with fixes
def create_and_checkout_branch(repo_path, branch_name):
    repo = Repo(repo_path)
    if not check_local_branch_exists(repo_path, branch_name):
        repo.git.branch(branch_name)
    repo.git.checkout(branch_name)


# Commit and push fixes in a new branch
def commit_and_push(repo_path, branch_name, commit_message):
    repo = Repo(repo_path)
    repo.git.add(A=True)
    repo.index.commit(commit_message)
    repo.git.push("origin", branch_name)

# Get all branches of the repository for the further checks
def get_branches(github_token_value, organization, repo_name):
    headers = {
        "Authorization": f"token {github_token_value}",
        "Content-Type": "application/json"
    }

    url = f"https://api.github.com/repos/{organization}/{repo_name}/branches"
    response = requests.get(url, headers=headers)

    if response.ok:
        branches = response.json()
    else:
        print(f"Error getting branches: {response.reason}")
        return None

    return [branch['name'] for branch in branches]

# We automatically create 2 branches with prefixes 001 and 002. Here we detect if such branches exist
def create_next_branch(github_token_value, organization, repo_name, source_branch, pull_request_number):
    all_branches = get_branches(github_token_value, organization, repo_name)
    print(all_branches)
    if not all_branches:
        return None

    base_name, _, current_number_str = source_branch.rpartition("-")
    if current_number_str.isdigit():
        current_number = int(current_number_str)
    else:
        current_number = 0
        base_name = source_branch

    next_number = current_number + 1
    next_branch_name = f"{base_name}-{next_number:03d}"
    # We check if AI branches with prefixes are already created. In case if this is not the first time we run AI handler for the same origin PR
    if next_branch_name in all_branches:
        comment = (
            f"A branch with SonarQube fixes {next_branch_name} already exist. Please review it and remove if this is not relevant anymore.")
        print(f"The branch '{next_branch_name}' already exists. Exiting the script.")
        post_github_comment(organization, repo_name, pull_request_number, github_token_value, comment)
        exit(0)
    # Only 2 iterations of branch creation allowed. If a new branch going to have a prefix 003 we interrupt the script and post a comment message in a PR
    if next_branch_name.endswith('-003'):
        print("Reached maximum iteration of script execution. Exiting the script.")
        comment = (
            "Reached maximum iteration of script execution. Please review AI generated branches, close or merge.")
        post_github_comment(organization, repo_name, pull_request_number, github_token_value, comment)
        exit(0)

    return next_branch_name


# Create a new pull request from a newly created branch with fixes
def create_pull_request(github_token_value, organization, repo_name, source_branch, sonar_analysis_branch):
    url = f"https://api.github.com/repos/{organization}/{repo_name}/pulls"
    headers = {
        "Authorization": f"token {github_token_value}",
        "Content-Type": "application/json"
    }

    data = {
        "title": "AI-generated Pull Request with fixed SONAR issues",
        "body": "AI-generated Pull Request with fixed SONAR issues",
        "head": sonar_analysis_branch,
        "base": source_branch
    }

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 201:
        return response.json()
    else:
        return None


# Necessary header with base64 encoding to properly connect to SonarCloud API
headers = {
    "Authorization": "Basic " + base64.b64encode((sonar_parameter_value + ":").encode()).decode()
}

# Update sonar_analysis_branch and local_repo_path variables
sonar_analysis_branch = create_next_branch(github_token_value, organization, repo_name, source_branch,
                                           pull_request_number)

# a variable to work with local git
local_repo_path = os.getenv("CODEBUILD_SRC_DIR")
if not sonar_analysis_branch:
    print("Failed to create next branch name.")
    exit(1)

# If we are able to create a new branch with the prefix 001 or 002 we handle the next logic
else:
    print(f"Next branch name: {sonar_analysis_branch}")
    # Create and switch to the new branch if it doesn't exist
    create_and_checkout_branch(local_repo_path, sonar_analysis_branch)

    # Get project quality gate status
    status_url = f"{sonar_url}/api/qualitygates/project_status?projectKey={project_key}&pullRequest={pull_request_number}"
    status_response = requests.get(status_url, headers=headers).json()

    # Handle issues based on quality_gate_status
    quality_gate_status = status_response["projectStatus"]["status"]

    # We use this flag to detect if we changed some files with AI fixes
    files_updated = False

    if quality_gate_status != "OK":
        # Extract issues and file paths
        issues_url = f"{sonar_url}/api/issues/search?projects=" + project_key + "&statuses=OPEN,REOPENED,CONFIRMED&pullRequest=" + pull_request_number
        issues_response = requests.get(issues_url, headers=headers).json()

        issues_by_file = defaultdict(list)
        # Group issues by file
        for issue in issues_response["issues"]:
            component = issue["component"]
            file_path = [comp["path"] for comp in issues_response["components"] if comp["key"] == component][0]
            message = issue["message"]
            issues_by_file[file_path].append(message)

        # Iterate over files with issues and process them
        for file_path, issues in issues_by_file.items():
            print(f"File: {file_path}")
            print(f"Issues: {issues}")

            # Read a file content
            try:
                with open(file_path, "r") as file:
                    file_content = file.read()
            except FileNotFoundError:
                print("  - File not found in the specified directory.")
                continue

            # Call communicate_with_ai function with file name and issues
            error_fix = communicate_with_ai(api_endpoint, ai_parameter_value, file_content, file_path, issues)

            # if we receive some answer from AI
            if error_fix:
                print(f"  - Suggested fix: {error_fix}")
                # Post the suggested fix as a comment on GitHub
                post_github_comment(organization, repo_name, pull_request_number, ai_parameter_value, error_fix,
                                    file_path)

                files_updated = True
                # Update the file content
                with open(file_path, "w") as file:
                    file.write(error_fix)

        # if we see some files changed after AI fix
        if files_updated:
            print("source_branch", source_branch)
            # Update the remote repository URL with the GitHub token for authentication
            update_remote_url_with_token(local_repo_path, github_token_value)
            # Commit and push the changes to the 'sonar-analysis' branch
            commit_and_push(local_repo_path, sonar_analysis_branch, "Automated sonar-analysis fixes")
            comment = f"A new branch with AI fixes created: https://github.com/{organization}/{repo_name}/tree/{sonar_analysis_branch}."
            post_github_comment(organization, repo_name, pull_request_number, github_token_value, comment)
            created_pull_request = create_pull_request(github_token_value, organization, repo_name, source_branch,
                                                       sonar_analysis_branch)
            # we left a comment if the PR created successfully
            if created_pull_request:
                print(f"Successfully created pull request with SonarQube fixes #{created_pull_request['number']}.")
                comment = f"Successfully created pull request with SonarQube fixes #{created_pull_request['number']}."
                post_github_comment(organization, repo_name, pull_request_number, github_token_value, comment)
            else:
                print("Failed to create a pull request.")
