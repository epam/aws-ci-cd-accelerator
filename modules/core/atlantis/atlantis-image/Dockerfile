# Build stage
FROM golang:1.22.1-alpine AS builder

RUN apk update && apk upgrade && apk add --no-cache curl && \
    # Install tfsec
    GO111MODULE=on go install github.com/aquasecurity/tfsec/cmd/tfsec@latest && \
    # Install TFLint
    curl -sL https://github.com/terraform-linters/tflint/releases/download/v0.48.0/tflint_linux_amd64.zip -o /tmp/tflint.zip && \
    unzip /tmp/tflint.zip -d /tmp && \
    install -v /tmp/tflint /bin && \
    rm /tmp/tflint.zip /tmp/tflint && \
    # Install Terragrunt
    curl -sL https://github.com/gruntwork-io/terragrunt/releases/download/v0.46.1/terragrunt_linux_amd64 -o /bin/terragrunt && \
    chmod +x /bin/terragrunt && \
    # Install Regula
    curl -sL https://github.com/fugue/regula/releases/download/v3.2.1/regula_3.2.1_Linux_x86_64.tar.gz -o /tmp/regula.tar.gz && \
    tar -xf /tmp/regula.tar.gz && \
    rm /tmp/regula.tar.gz && \
    mv regula /bin && \
    # Install Infracost
    curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh && \
    # Install kubectl
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /bin/kubectl && \
    rm -rf /var/cache/apk/* /tmp/*

# Final stage
FROM ghcr.io/runatlantis/atlantis:v0.27.1

USER root

RUN apk update && apk upgrade && \
    apk add  --update --no-cache jq gcc musl-dev libffi-dev openssl-dev curl python3 py3-pip aws-cli && \
    ln -sf python3 /usr/bin/python && rm -rf /var/cache/apk/* /tmp/*

USER atlantis

## Install Checkov
COPY requirements.txt /home/atlantis/
RUN python3 -m venv /home/atlantis/.venv && \
    source /home/atlantis/.venv/bin/activate && \
    pip install --upgrade setuptools -q && pip install -U -q checkov && \
    pip install -r /home/atlantis/requirements.txt && \
    deactivate && \
    rm -rf  /var/cache/apk/* /tmp/*

## Install EPAM Syndicate Rule Engine
COPY c7n*.gz /home/atlantis/custodian/
RUN python3 -m venv /home/atlantis/.venv_syndicate \
   && [ ! -d /home/atlantis/custodian/ ] \
   || (source /home/atlantis/.venv_syndicate/bin/activate \
   && pip install /home/atlantis/custodian/c7n*.gz \
   && rm -rf  /var/cache/apk/* /tmp/* \
   && deactivate)

COPY --from=builder /go/bin/tfsec /usr/local/bin
COPY --from=builder /bin/tflint /usr/local/bin/tflint
COPY --from=builder /bin/regula /usr/local/bin/regula
COPY --from=builder /bin/terragrunt /usr/local/bin/terragrunt
COPY --from=builder /usr/local/bin/infracost /usr/local/bin/infracost
COPY --from=builder /bin/kubectl /usr/local/bin/kubectl
