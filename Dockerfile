# kubectl-convert
FROM golang:1.16.4-buster@sha256:ab32429d40c1b734ed4f036838ac516352182f9414563478fa88a1553c4a4414 AS golang

RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b v1.21.0
RUN cd kubernetes && go install ./cmd/kubectl-convert

# renovate
FROM renovate/renovate:25.24.0@sha256:5d434d41305eea7ad591e271e981696ea6a771b90156d1e25da7d38ba4ec8d2e

COPY --from=golang /go/bin/kubectl-convert /go/bin/kubectl-convert

USER root

RUN apt-get update \
 && apt-get install -y ca-certificates

RUN update-ca-certificates

# vum ex curl jq
RUN apt install -y vim curl jq

# yq
RUN pip3 install yq

# helmfile
ENV HELMFILE_VERSION=v0.139.6
RUN curl -fsSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile

# kustomize
ENV KUSTOMIZE_VERSION=4.1.2
RUN curl -fsSL -o /usr/local/bin/install_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh && \
    chmod +x /usr/local/bin/install_kustomize.sh && \
    install_kustomize.sh ${KUSTOMIZE_VERSION} /usr/local/bin/

USER ubuntu

# checks
RUN curl --version
RUN jq --version
RUN yq --version
RUN go version
RUN renovate --version
RUN ssh-keyscan gitlab.com
RUN helm version
RUN helmfile version
RUN kustomize version
