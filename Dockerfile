ARG TERRAFORM_VERSION=0.14.8
ARG TERRAGRUNT_VERSION=0.28.15

FROM docker.mirror.hashicorp.services/golang:alpine as builder
ARG TARGETPLATFORM

RUN export TARGET_ARCHITECTURE=$(echo $TARGETPLATFORM | sed 's/^.*\///g')
RUN apk add --no-cache git bash openssh curl
RUN curl -sSLO https://github.com/hashicorp/terraform/archive/v${TERRAFORM_VERSION}.zip
RUN unzip v${TERRAFORM_VERSION}.zip
RUN cd terraform-${TERRAFORM_VERSION} && \
	 XC_ARCH=$TARGET_ARCHITECTURE XC_OS=linux bash scripts/build.sh && \
	 cp bin/terraform ../

FROM ubuntu:20.04
ARG TARGETPLATFORM

COPY --from=0 /go/terraform /usr/local/bin
RUN export DEBIAN_FRONTEND=noninteractive && \
    export TARGET_ARCHITECTURE=$(echo $TARGETPLATFORM | sed 's/^.*\///g') && \
	apt-get update && \
	apt-get upgrade -y --quiet > /dev/null && \
	apt-get install -y --quiet python3-pip software-properties-common apt-utils apt-transport-https build-essential curl git && \
	pip3 install awscli awsume && \
	apt-get update && \
	apt-get install -y --quiet terraform && \
	curl -sSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_$TARGET_ARCHITECTURE && \
	chmod +x /usr/local/bin/terragrunt && \
	rm -rf /var/lib/apt/lists/*
