# kubectl-convert
FROM golang:1.20.5-buster@sha256:eb3f9ac805435c1b2c965d63ce460988e1000058e1f67881324746362baf9572 AS golang
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]
ENV CGO_ENABLED=0

ENV KUBERNETES_VERSION=v1.29.3
RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b ${KUBERNETES_VERSION}
RUN cd kubernetes && go install -ldflags '-s -w' ./cmd/kubectl-convert

ENV CHART_PRETTIER_VERSION=v1.2.2
RUN set -eux; \
    go install -ldflags '-s -w' "github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION:?}"

# renovate
FROM renovate/renovate:37.273.0-full@sha256:926d5927e30e29c5f213460d2305f0a90d4ef0c2f3ab44bc6c1f7ae8fcb90710
SHELL [ "/usr/bin/bash", "-o", "pipefail", "-c" ]

USER root

# gofmt
RUN set -eux; \
    ln -s "$(find / -type f -executable -name gofmt -print -quit 2>/dev/null)" /usr/local/bin/gofmt; \
    which gofmt | tee /dev/stderr | grep -Fqx /usr/local/bin/gofmt; \
    gofmt -h

# vum ex curl jq
RUN set -eux; \
    apt-get update; \
    DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends \
        curl \
        jq \
        vim \
        ; \
    apt-get clean; \
    rm -fr /var/lib/apt/lists/*

# yq
RUN pip3 install yq --no-cache-dir

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
COPY --from=golang /go/bin/chart-prettier /go/bin/kubectl-convert /usr/local/bin/

USER ubuntu

# checks
RUN set -eux; \
    chart-prettier -h; \
    curl --version; \
    go version; \
    gofmt --help; \
    helm version; \
    helmfile version; \
    jq --version; \
    kubectl-convert --help; \
    kustomize version; \
    renovate --version; \
    ssh-keyscan gitlab.com; \
    yq --version
