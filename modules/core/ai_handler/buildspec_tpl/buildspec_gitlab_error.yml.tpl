version: 0.2

env:
  parameter-store:
    OPENAI_TOKEN: "$${OPENAI_TOKEN_NAME}"
    GIT_TOKEN: "$${GIT_TOKEN_NAME}"
  variables:
    LLM_MODEL: ""
    OPENAI_API_ENDPOINT: ""
    PULL_NUM: ""
    SOURCE_BRANCH: ""
    GIT_HOSTNAME: ""
    GIT_USER: ""
    REPO_OWNER: ""
    REPO_NAME: ""
    BUCKET_NAME: ""
    VCS: ""
    PYTHONUNBUFFERED: 1

phases:
  install:
    commands:
      - apt-get update -qq
      - git clone "https://$${GIT_USER}:$${GIT_TOKEN}@$${GIT_HOSTNAME}/$${REPO_OWNER}/$${REPO_NAME}.git"
      - cd $${REPO_NAME}
      - git checkout "$${SOURCE_BRANCH}"
      - git branch --show-current
      - pip install -r modules/core/ai_handler/codebuild_scripts/requirements.txt -qq
      - aws s3 cp s3://$${BUCKET_NAME}/$${REPO_NAME}/error.log /tmp/
  build:
    commands:
      - python modules/core/ai_handler/codebuild_scripts/ai_$${VCS}_analyzer.py
      - cat /tmp/extracted_errors.log
      - cat /tmp/error_fix.log
      - aws s3 cp /tmp/error_fix.log s3://$${BUCKET_NAME}/$${REPO_NAME}/
      - aws s3 cp /tmp/extracted_errors.log s3://$${BUCKET_NAME}/$${REPO_NAME}/
