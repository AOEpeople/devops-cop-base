FROM ubuntu:20.04

RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get upgrade -y --quiet > /dev/null && \
	apt-get install -y --quiet python3-pip software-properties-common apt-utils apt-transport-https build-essential curl git && \
	curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
	apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com focal main" && \
	apt-get update && \
	pip3 install awscli awsume && \
	apt-get update && \
	apt-get install -y --quiet terraform && \
	curl -sSL -o /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v0.28.9/terragrunt_linux_amd64 && \
	chmod +x /usr/local/bin/terragrunt && \
	rm -rf /var/lib/apt/lists/*
