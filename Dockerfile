FROM docker.mirror.hashicorp.services/golang:alpine as builder
ARG TARGETARCH
ARG TERRAFORM_VERSION=0.14.8
ARG HELMDIFF_VERSION=3.1.3

RUN go get -u golang.org/x/lint/golint

RUN apk add --no-cache git bash openssh curl make gcc g++ libc-dev
RUN curl -sSL -o terraform.zip https://github.com/hashicorp/terraform/archive/v${TERRAFORM_VERSION}.zip
RUN unzip terraform.zip >/dev/null
RUN cd terraform-${TERRAFORM_VERSION} && \
	 XC_ARCH=$TARGETARCH XC_OS=linux bash scripts/build.sh && \
	 cp bin/terraform ../ && \
	 cd /go

RUN curl -sSL -o helm-diff.zip https://github.com/databus23/helm-diff/archive/refs/tags/v3.1.3.zip
RUN unzip helm-diff.zip >/dev/null
RUN cd helm-diff-${HELMDIFF_VERSION} && \
	 XC_ARCH=$TARGETARCH XC_OS=linux make build && \
	 mkdir -p /go/dist/helm-diff && \
	 cp ./bin/diff /go/dist/helm-diff/bin && \
     cp ./plugin.yaml /go/dist/helm-diff

FROM ubuntu:20.04
ARG TARGETARCH
ARG TERRAGRUNT_VERSION=0.28.15
ARG VAULT_VERSION=1.7.3
ARG HELMFILE_VERSION=0.140.0

COPY --from=builder /go/terraform /usr/local/bin
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y --quiet > /dev/null && \
	apt-get install -y --quiet python3-pip software-properties-common apt-utils apt-transport-https build-essential curl git jq unzip && \
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - && \
        echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list && \
	curl -s https://baltocdn.com/helm/signing.asc | apt-key add - && \
	echo "deb https://baltocdn.com/helm/stable/debian/ all main" > /etc/apt/sources.list.d/helm-stable-debian.list && \
        apt-get update && \
	apt-get install -y kubectl && \
	apt-get install -y helm && \
	pip3 install awscli awsume && \
	rm -rf /var/lib/apt/lists/*

COPY --from=builder /go/dist/helm-diff /root/.local/share/helm/plugins/helm-diff

RUN curl -sSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_$TARGETARCH && \
	chmod +x /usr/local/bin/helmfile
	
RUN curl -sSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_$TARGETARCH && \
	chmod +x /usr/local/bin/terragrunt

RUN curl -sSL -o vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    unzip vault.zip > /dev/null && \
    mv vault /usr/local/bin && \
    rm vault.zip