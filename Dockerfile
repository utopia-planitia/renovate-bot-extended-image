# kubectl-convert
FROM golang:1.19.2-buster@sha256:403f38941d7643bc91fad0227ebee6ddd80159b79fc339f6702271a2679a5f11 AS golang
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

ENV KUBERNETES_VERSION=v1.25.3
RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b ${KUBERNETES_VERSION}
RUN cd kubernetes && go install ./cmd/kubectl-convert

ENV CHART_PRETTIER_VERSION=v1.2.2
RUN set -eux; \
    go install "github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION:?}"

# renovate
FROM renovate/renovate:33.1.0@sha256:17cc14aaaac3cb2127b7235d728ac9eea8824c9bcd1801e4a8fcb34fa9a4dc58
SHELL [ "/usr/bin/bash", "-o", "pipefail", "-c" ]

USER root

RUN apt-get update

# gofmt
RUN set -eux; \
    ln -s "$(find / -type f -executable -name gofmt -print -quit 2>/dev/null)" /usr/local/bin/gofmt; \
    which gofmt | tee /dev/stderr | grep -Fqx /usr/local/bin/gofmt; \
    gofmt -h

# vum ex curl jq
RUN apt install -y vim curl jq

# yq
RUN pip3 install yq

# helmfile
ENV HELMFILE_VERSION=v0.144.0
RUN curl -fsSL -o /usr/local/bin/helmfile https://github.com/roboll/helmfile/releases/download/${HELMFILE_VERSION}/helmfile_linux_amd64 && \
    chmod +x /usr/local/bin/helmfile

# kustomize
ENV KUSTOMIZE_VERSION=4.1.2
RUN curl -fsSL -o /usr/local/bin/install_kustomize.sh https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh && \
    chmod +x /usr/local/bin/install_kustomize.sh && \
    install_kustomize.sh ${KUSTOMIZE_VERSION} /usr/local/bin/

# compiled tools
COPY --from=golang /go/bin/kubectl-convert /usr/local/bin/kubectl-convert
COPY --from=golang /go/bin/chart-prettier /usr/local/bin/chart-prettier

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
RUN chart-prettier -h
RUN which gofmt
