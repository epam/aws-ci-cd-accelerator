import os
import logging
from openai import OpenAI

llm_model = os.environ.get("LLM_MODEL", "gpt-3.5-turbo")
output_file_name = "/tmp/report.log"
api_key = os.environ.get('OPENAI_TOKEN', "")


def communicate_with_ai(prompt):
    client = OpenAI(api_key=api_key)

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
        error_fix = response.choices[0].message.content.strip()
        # If the model generates a JSON, parse it
        return error_fix
    else:
        print('Failed to communicate with AI.')
        return None


def main():
    logging.info("Starting main function.")

    with open(output_file_name) as file:
        report = file.read()
        file.close()
    prompt = f'''Given the Terraform scan report below, there are several checks failed due to misconfigurations
        in the Terraform code. Please provide code corrections in Terraform code for each of these
        issues.\n {report}'''
    issue_fix = communicate_with_ai(prompt)

    print(issue_fix)


if __name__ == "__main__":
    main()
