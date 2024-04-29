ARG BASE_VER=2023.4.20240416.0
FROM amazonlinux:${BASE_VER}

ARG LOCAL_TIME=New_York
ARG ARCH=amd64
ARG OPENTOFU_VER=1.6.2
ARG TERRAFORM_DOC_VER=0.17.0
ARG AWSCLI2_VER=aarch64-2.15.41
ARG JQ_VER=1.7.1
ARG YQ_VER=4.43.1
ARG KUBECTL_VER=1.30.0
ARG HELM_VER=3.14.4

COPY .bashrc /root/.bashrc

RUN yum update -y && \
  yum install wget git tar vi which unzip shadow-utils -y && \
  curl -sLo tofu.zip https://github.com/opentofu/opentofu/releases/download/v${OPENTOFU_VER}/tofu_${OPENTOFU_VER}_linux_amd64.zip && \
  unzip tofu.zip && \
  chmod +x tofu && \
  mv tofu /usr/local/bin/tofu && \
  rm -f tofu.zip *.md LICENSE && \
  curl -sLo tfdocs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v${TERRAFORM_DOC_VER}/terraform-docs-v${TERRAFORM_DOC_VER}-linux-${ARCH}.tar.gz && \
  tar -xf tfdocs.tar.gz && \
  chmod +x terraform-docs && \
  mv terraform-docs /usr/local/bin/terraform-docs && \
  rm -f tfdocs.tar.gz && \
  curl -sLo jq https://github.com/stedolan/jq/releases/download/jq-${JQ_VER}/jq-linux64 && \
  chmod +x jq && \
  mv jq /usr/local/bin/jq && \
  curl -sLo yq https://github.com/mikefarah/yq/releases/download/v${YQ_VER}/yq_linux_amd64 && \
  chmod +x yq && \
  mv yq /usr/local/bin/yq && \
  curl -sLo awscliv2.zip https://awscli.amazonaws.com/awscli-exe-linux-${AWSCLI2_VER}.zip && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -fr aws && \
  rm -f awscliv2.zip && \
  curl -sLo ./kubectl https://dl.k8s.io/release/v${KUBECTL_VER}/bin/linux/amd64/kubectl && \
  chmod +x kubectl && \
  mv kubectl /usr/local/bin/kubectl && \
  curl -sLo ./helm.tar.gz https://get.helm.sh/helm-v${HELM_VER}-linux-amd64.tar.gz && \
  tar -xf helm.tar.gz && \
  mv linux-amd64/helm /usr/local/bin/helm && \
  chown root:root /usr/local/bin/helm && \
  rm -f helm.tar.gz && \
  rm -fr linux-amd64 && \
  rm -f /etc/localtime && \
  ln -s /usr/share/zoneinfo/America/$LOCAL_TIME /etc/localtime && \
  yum clean all && \
  rm -rf /var/cache/yum && \
  source /root/.bashrc

WORKDIR /root
