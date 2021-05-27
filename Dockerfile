# kubectl-convert
FROM golang:1.16.4-buster@sha256:a093370eb1e29c5252dcb1d62e4f3547fcaf348b6719794f21875075e3e0fd6d AS golang

RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b v1.21.0
RUN cd kubernetes && go install ./cmd/kubectl-convert

# renovate
FROM renovate/renovate:25.31.10@sha256:d46eaa78228925a5b6dfd61c5f6bd03706a65995a0aa234abe528744ba788450

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
ENV HELMFILE_VERSION=v0.139.7
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
