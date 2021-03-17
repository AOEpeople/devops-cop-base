FROM docker.mirror.hashicorp.services/golang:alpine as builder
ARG TARGETARCH
ARG TERRAFORM_VERSION=0.14.8

RUN apk add --no-cache git bash openssh curl
RUN curl -sSL -o terraform.zip https://github.com/hashicorp/terraform/archive/v${TERRAFORM_VERSION}.zip
RUN unzip terraform.zip >/dev/null
RUN cd terraform-${TERRAFORM_VERSION} && \
	 XC_ARCH=$TARGETARCH XC_OS=linux bash scripts/build.sh && \
	 cp bin/terraform ../

FROM ubuntu:20.04
ARG TARGETARCH
ARG TERRAGRUNT_VERSION=0.28.15

COPY --from=0 /go/terraform /usr/local/bin
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y --quiet > /dev/null && \
	apt-get install -y --quiet python3-pip software-properties-common apt-utils apt-transport-https build-essential curl git && \
	pip3 install awscli awsume && \
	rm -rf /var/lib/apt/lists/*
	
RUN curl -sSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_$TARGETARCH && \
	chmod +x /usr/local/bin/terragrunt
