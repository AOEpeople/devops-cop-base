FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM ubuntu:22.04
ARG TARGETARCH
ARG TERRAFORM_VERSION=0.15.5
ARG TERRAGRUNT_VERSION=0.36.1
ARG VAULT_VERSION=1.7.3
ARG HELMFILE_VERSION=0.142.0
ARG COSIGN_VERSION=1.5.2

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y --quiet > /dev/null && \
	apt-get install -y --quiet python3-pip software-properties-common apt-utils apt-transport-https build-essential curl git jq unzip ca-certificates gnupg lsb-release && \
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list && \
	curl -s https://baltocdn.com/helm/signing.asc | apt-key add - && \
	echo "deb https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm-stable-debian.list && \
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list && \
    apt-get update && \
	apt-get install -y kubectl && \
	apt-get install -y helm && \
	apt-get install -y docker-ce-cli && \
	pip3 install awsume && \
	rm -rf /var/lib/apt/lists/*

RUN curl -sSL -o terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    mv terraform /usr/local/bin/terraform && \
    terraform -version

RUN helm plugin install https://github.com/databus23/helm-diff && \
    helm diff version

RUN curl -sSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_${TARGETARCH} && \
	chmod +x /usr/local/bin/helmfile && \
	helmfile version

RUN curl -sSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH} && \
	chmod +x /usr/local/bin/terragrunt && \
    terragrunt -version

RUN curl -sSL -o vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    unzip vault.zip > /dev/null && \
    mv vault /usr/local/bin && \
    rm vault.zip && \
    vault --version

RUN if [ "${TARGETARCH}" = "amd64" ] ; then \
    curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"; \
  else \
    curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-aarch64.zip" -o "awscliv2.zip"; \
  fi && \
  unzip -q awscliv2.zip && \
  ./aws/install && \
  rm -rf awscliv2.zip && \
  rm -rf aws/ && \
  aws --version

RUN curl -sSL -o cosign https://github.com/sigstore/cosign/releases/download/v${COSIGN_VERSION}/cosign-linux-${TARGETARCH} && \
    install -o root -g root -m 0755 cosign /usr/local/bin/cosign && \
    cosign version

COPY --from=kaniko /kaniko/executor /kaniko/
COPY --from=kaniko /kaniko/docker-credential-ecr-login /kaniko/
ENV PATH=/kaniko:$PATH