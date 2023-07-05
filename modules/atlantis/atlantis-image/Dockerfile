# Build stage
FROM golang:1.20.4-alpine as builder

RUN apk update && apk upgrade && apk add --no-cache curl

# Install tfsec
ENV GO111MODULE=on
RUN go install github.com/aquasecurity/tfsec/cmd/tfsec@latest

# Install TFLint
RUN wget -O /tmp/tflint.zip https://github.com/terraform-linters/tflint/releases/download/v0.46.1/tflint_linux_amd64.zip && \
    unzip /tmp/tflint.zip -d /tmp && \
    install -v /tmp/tflint /bin && \
    rm /tmp/tflint.zip /tmp/tflint

# Install Terragrunt
RUN wget -O /bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.46.1/terragrunt_linux_amd64 && \
    chmod +x /bin/terragrunt

# Install Regula
RUN wget -O /tmp/regula.tar.gz https://github.com/fugue/regula/releases/download/v3.2.1/regula_3.2.1_Linux_x86_64.tar.gz && \
    tar -xvf /tmp/regula.tar.gz && \
    rm /tmp/regula.tar.gz && \
    mv regula /bin

# Install Infracost
RUN curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh

# Install kubectl
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    install -o root -g root -m 0755 kubectl /bin/kubectl

# Final stage
FROM ghcr.io/runatlantis/atlantis:v0.24.1

RUN apk update && apk upgrade && \
    apk add --no-cache jq py3-pip gcc python3-dev musl-dev libffi-dev && \
    pip3 install --upgrade pip setuptools wheel awscli c7n checkov && \
    rm -rf /var/cache/apk/*

# Install Epam Custodian
COPY c7n*.zip /c7n/
RUN python3 -m venv /home/atlantis/.venv
RUN [ ! -d /c7n ] \
|| (source /home/atlantis/.venv/bin/activate \
&& pip install /c7n/c7n*.zip \
&& rm -rf /c7n \
&& deactivate)

COPY --from=builder /go/bin/tfsec /usr/local/bin
COPY --from=builder /bin/tflint /usr/local/bin/tflint
COPY --from=builder /bin/regula /usr/local/bin/regula
COPY --from=builder /bin/terragrunt /usr/local/bin/terragrunt
COPY --from=builder /usr/local/bin/infracost /usr/local/bin/infracost
COPY --from=builder /bin/kubectl /usr/local/bin/kubectl