# About

This repository provides a base images with [Terraform](https://www.terraform.io/), [Terragrunt](https://terragrunt.gruntwork.io/) and common Kubernetes Tools.

The resulting images are tagged along the main Terraform versions. Use it with:

```
docker pull ghcr.io/aoepeople/devops-cop-base:v1.0.2
```

Available tags can be found [here](https://github.com/orgs/AOEpeople/packages/container/package/devops-cop-base)

Included tools:

* [Terraform](https://github.com/hashicorp/terraform) - version pinned
* [Terragrunt](https://github.com/gruntwork-io/terragrunt)
* [Vault](https://github.com/hashicorp/vault)
* [Kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
* [Helm](https://helm.sh/)
* [Helmfile](https://github.com/roboll/helmfile)
* [awsume](https://awsu.me/)
