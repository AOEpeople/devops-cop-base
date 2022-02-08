FROM ubuntu:20.04
ARG TARGETARCH
ARG TERRAFORM_VERSION=0.15.5
ARG TERRAGRUNT_VERSION=0.35.9
ARG VAULT_VERSION=1.7.3
ARG HELMFILE_VERSION=0.142.0

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
	pip3 install awscli awsume && \
	rm -rf /var/lib/apt/lists/*

RUN curl -sSL -o terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    mv terraform /usr/local/bin/terraform

RUN helm plugin install https://github.com/databus23/helm-diff

RUN curl -sSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_$TARGETARCH && \
	chmod +x /usr/local/bin/helmfile
	
RUN curl -sSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_$TARGETARCH && \
	chmod +x /usr/local/bin/terragrunt

RUN curl -sSL -o vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    unzip vault.zip > /dev/null && \
    mv vault /usr/local/bin && \
    rm vault.zip
