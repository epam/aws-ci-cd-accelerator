import json
import boto3
import os
import time
import requests
from git import Repo

# Settings for AI parameters
api_endpoint = os.environ.get('OPENAI_API_ENDPOINT', "https://api.openai.com/v1/completions")
openai_token = os.getenv("OPENAI_TOKEN")
llm_model = os.environ.get("LLM_MODEL", "text-davinci-003")

# Get source branch name
source_branch = os.getenv("SOURCE_BRANCH")

# Get local repository path
local_repo_path = os.getenv("CODEBUILD_SRC_DIR")

# using an access token
github_access_token = os.getenv("GITHUB_TOKEN")


# We use this function to overwrite a regular repo URL to one which uses a Token for authentication
def update_remote_url_with_token(repo_path, github_access_token):
    repo = Repo(repo_path)
    remote_url = repo.remotes.origin.url
    new_url = remote_url.replace("https://", f"https://{github_access_token}@")
    repo.remotes.origin.set_url(new_url)


# This function for check if the branch <source-branch>-ai-handler already exist. If exist we going to interrupt the script
def check_branch_exists(github_access_token, owner, repo_name, ai_handler_branch):
    found = False
    headers = {
        "Authorization": f"token {github_access_token}",
        "Content-Type": "application/json"
    }
    # Get the list of branches from the remote repository
    url = f"https://api.github.com/repos/{owner}/{repo_name}/branches"
    # Send the GET request with the headers
    response = requests.get(url, headers=headers)

    if response.status_code == 200:
        # Extract the branch names from the response
        branch_names = [branch["name"] for branch in response.json()]

        # Check if the target branch or an -ai-handler version of it exists
        if ai_handler_branch in branch_names:
            found = True
            print("AI-Handler branch already exist")
        else:
            # found = False
            print("AI-Handler branch doesn`t exist yet")
    return found


# If we provide pr option in the comment of PR we use this function to create a new branch with AI fixes
def create_and_checkout_branch(repo_path, branch_name):
    repo = Repo(repo_path)
    repo.git.branch(branch_name)
    repo.git.checkout(branch_name)


# We commit our changes and push the code to a new branch
def commit_and_push(repo_path, branch_name, commit_message):
    repo = Repo(repo_path)
    repo.git.add(A=True)
    repo.index.commit(commit_message)
    repo.git.push("origin", branch_name)


# Create a new pull request from the newly created branch
def create_pull_request(github_access_token, owner, repo_name, source_branch, ai_handler_branch):
    url = f"https://api.github.com/repos/{owner}/{repo_name}/pulls"
    headers = {
        "Authorization": f"token {github_access_token}",
        "Content-Type": "application/json"
    }

    data = {
        "title": "A Pull Request created by AI Handler",
        "body": "A Pull Request created by AI Handler",
        "head": ai_handler_branch,
        "base": source_branch
    }

    response = requests.post(url, headers=headers, json=data)

    if response.status_code == 201:
        return response.json()
    else:
        return None


# We use this function to post results in the comments or notify a user in the PR comments
def post_github_comment(owner, repo_name, pull_request_number, github_access_token, response_text, as_text=False):
    url = f"https://api.github.com/repos/{owner}/{repo_name}/issues/{pull_request_number}/comments"
    headers = {
        "Authorization": f"token {github_access_token}",
        "Content-Type": "application/json"
    }
    if as_text:
        data = {
            "body": f"{response_text}"
        }
    else:
        data = {
            "body": f"```\n{response_text}\n```"
        }
    response = requests.post(url, headers=headers, json=data)
    print("response code:", response)
    return response.json()


# Function for AI
def communicate_with_ai(api_endpoint, openai_token, file_content, action_type):
    request_headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer " + openai_token
    }
    # Depends on action type different prompt
    if action_type == 'unit_test':
        prompt = f"Please rewrite the code below and add unit tests for it:\n {file_content}\n"
    elif action_type == 'doc':
        prompt = f"read this code and give a step-by-step explanation how it works\n {file_content}\n"
    elif action_type == 'comment':
        prompt = f"review this code and cover it completely with comments\n {file_content}\n"
    else:
        raise ValueError("Invalid action_type provided")
    request_data = {
        "model": f"{llm_model}",
        "prompt": prompt,
        "max_tokens": 2000,
        "temperature": 0.5
    }

    response = requests.post(api_endpoint, headers=request_headers, json=request_data)

    if response.status_code == 200:
        output = response.json()["choices"][0]["text"]
        return output
    else:
        return None


# Main function
def main():
    owner = os.getenv("OWNER")
    repo_name = os.getenv("REPO_NAME")
    pull_request_number = os.getenv("PULL_NUM")
    file_name = os.getenv("FILE_NAME")
    action_type = os.getenv("ACTION_TYPE")
    pr_create = os.getenv("PR_CREATE")

    # AI Handler branch name
    ai_handler_branch = f"{source_branch}-ai-handler"

    # This variable will catch a status of a function if the branch <source_branch>-ai-handler already exist
    branch_exist = check_branch_exists(github_access_token, owner, repo_name, ai_handler_branch)

    # First case when we do not need to create a new PR
    # Lambda pass pr_create value as string that is why we embrace it in ""
    if pr_create == "0":
        print("PR creation doesn`t set. Print the result as PR comment")
        try:
            # Read the file content locally
            with open(file_name, 'r') as file:
                # Read the lines of the file as a list
                file_content = file.readlines()

            # Connect with AI
            response_text = communicate_with_ai(api_endpoint, openai_token, file_content, action_type)

            # Post the comment in PR comment of GitHub
            post_github_comment(owner, repo_name, pull_request_number, github_access_token, response_text)

        # If we have provided some wrong file path/name we print the error in pr comments
        except Exception as ex:
            # An error occurred, print the error message
            print(f"Error: {str(ex)}")
            error_message = "A target file was not found and can`t be read. Please check the file path and try again."
            post_github_comment(owner, repo_name, pull_request_number, github_access_token, error_message, as_text=True)

    # The case if we need a new PR but a branch <source_branch>-ai-handler already exists for some reason
    # We notify a user we can not create it
    elif pr_create == "1" and branch_exist == True:
        print("A new PR can`t be created since the branch created by AI-Handler already exist")
        error_message = f"A branch {ai_handler_branch} already exist. Please review it, merge or remove."
        post_github_comment(owner, repo_name, pull_request_number, github_access_token, error_message, as_text=True)

    # The case if we need a new PR and there is no branch with the name <source_branch>-ai-handler
    elif pr_create == "1" and branch_exist == False:
        print("Going to create a new PR")
        # Read the file content for the further handling with AI
        try:
            # Read the file content locally
            with open(file_name, 'r') as file:
                # Read the lines of the file as a list
                file_content = file.readlines()

        # If the file path/name was set incorrectly we post a message in PR comments
        except Exception as ex:
            error_message = "A target file was not found and can`t be read. Please check the file path and try again."
            post_github_comment(owner, repo_name, pull_request_number, github_access_token, error_message, as_text=True)
            print(f"Error: {str(ex)}")

        # Connect with AI and receive an output from it
        response_text = communicate_with_ai(api_endpoint, openai_token, file_content, action_type)

        # We create and switch to the new branch if it doesn't exist before overwrite the file
        create_and_checkout_branch(local_repo_path, ai_handler_branch)

        # Overwrite the file content by the output we have received from AI
        try:
            with open(file_name, "w") as file:
                file.write(response_text)
        # If the file path/name was set incorrectly we post a message in PR comments
        except Exception as ex:
            error_message = "A target file can`t be overwritten. Please check the file path and try again."
            post_github_comment(owner, repo_name, pull_request_number, github_access_token, error_message, as_text=True)
            print(f"Error: {str(ex)}")

        # Update the remote repository URL with the GitHub token for authentication
        update_remote_url_with_token(local_repo_path, github_access_token)

        # Commit and push the changes to the 'ai-handler' branch
        commit_and_push(local_repo_path, ai_handler_branch, "AI-Handler proposal")

        comment = f"A new branch with AI fixes created: https://github.com/{owner}/{repo_name}/tree/{ai_handler_branch}. Please review it."
        post_github_comment(owner, repo_name, pull_request_number, github_access_token, comment, as_text=True)

        # Create a pull request for the AI-generated fixes
        created_pull_request = create_pull_request(github_access_token, owner, repo_name, source_branch,
                                                   ai_handler_branch)
        if created_pull_request:
            print(f"Successfully created pull request #{created_pull_request['number']}.")
            comment = f"Successfully created pull request #{created_pull_request['number']}."
            post_github_comment(owner, repo_name, pull_request_number, github_access_token, comment, as_text=True)
        else:
            print("Failed to create a pull request.")


if __name__ == "__main__":
    main()
