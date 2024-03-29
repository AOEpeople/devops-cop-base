FROM gcr.io/kaniko-project/executor:debug as kaniko

FROM docker.io/bitnami/minideb:buster
LABEL maintainer "aoepeople <aoepeople@aoe.com>"
ARG TARGETARCH


ENV HOME="/" \
    OS_ARCH="amd64" \
    OS_FLAVOUR="debian-10" \
    OS_NAME="linux" \
    PATH="/opt/aoepeople/bin:$PATH"

COPY prebuildfs /

ARG HELMFILE_VERSION=0.142.0
ARG HELM_VERSION=3.8.0
ARG KUBECTL_VERSION=1.23.3
ARG TERRAFORM_VERSION=0.15.5
ARG TERRAGRUNT_VERSION=0.36.1
ARG VAULT_VERSION=1.7.3
ARG COSIGN_VERSION=1.5.2

RUN mkdir -p /opt/aoepeople/bin && \
    install_packages ca-certificates gnupg curl gzip jq procps tar wget unzip git awscli

RUN curl -sSLO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl" && \
#    curl -LO "https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/${OS_ARCH}/kubectl.sha256" && \w
#    echo "$(<kubectl.sha256)  kubectl" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl /opt/aoepeople/bin/kubectl && \
    mkdir /.kube && chmod g+rwX /.kube && \
    kubectl version --client=true

RUN curl -sSLO "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${TARGETARCH}/kubectl-convert" && \
# curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl-convert.sha256" && \
# echo "$(<kubectl-convert.sha256) kubectl-convert" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl-convert /opt/aoepeople/bin/kubectl-convert

RUN curl -sSL -o terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    rm terraform_${TERRAFORM_VERSION}_linux_${TARGETARCH}.zip && \
    install -o root -g root -m 0755 terraform /opt/aoepeople/bin/terraform && \
    rm terraform && \
    terraform -version

RUN curl -sSL -o helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz https://get.helm.sh/helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz && \
    tar -xzf helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz && \
    install -o root -g root -m 0755 linux-${TARGETARCH}/helm /opt/aoepeople/bin/helm && \
    rm helm-v${HELM_VERSION}-linux-${TARGETARCH}.tar.gz && \
    rm -Rf linux-${TARGETARCH} && \
    helm version

RUN helm plugin install https://github.com/databus23/helm-diff && \
    helm diff version

RUN curl -sSL -o helmfile https://github.com/roboll/helmfile/releases/download/v${HELMFILE_VERSION}/helmfile_linux_${TARGETARCH} && \
    install -o root -g root -m 0755 helmfile /opt/aoepeople/bin/helmfile && \
	rm helmfile && \
    helmfile version

RUN curl -sSL -o terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_${TARGETARCH} && \
    install -o root -g root -m 0755 terragrunt /opt/aoepeople/bin/terragrunt && \
    rm terragrunt && \
    terragrunt -version

RUN curl -sSL -o vault.zip https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_${TARGETARCH}.zip && \
    unzip vault.zip > /dev/null && \
    install -o root -g root -m 0755 vault /opt/aoepeople/bin/vault && \
    rm vault && \
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
    install -o root -g root -m 0755 cosign /opt/aoepeople/bin/cosign && \
    cosign version

COPY --from=kaniko /kaniko/executor /kaniko/
COPY --from=kaniko /kaniko/docker-credential-ecr-login /kaniko/
ENV PATH=/kaniko:$PATH