# kubectl-convert
FROM golang:1.16.4-buster@sha256:cf375ff9bb4218ec131ed955c9d1e5d0f8d2ee6b0bf7c0563eb01aa4e7a0d15a AS golang

RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b v1.21.0
RUN cd kubernetes && go install ./cmd/kubectl-convert

# renovate
FROM renovate/renovate:25.31.11@sha256:92b87a7503786cbb99a6b0cca2a7ad5000158b9440ca207677932501e761c675

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
