FROM docker.io/library/golang:1.23.0-alpine@sha256:d0b31558e6b3e4cc59f6011d79905835108c919143ebecc58f35965bf79948f4 AS golang
SHELL [ "/bin/ash", "-o", "pipefail", "-c" ]
RUN set -eux; \
    apk upgrade --no-cache; \
    apk add --no-cache git
ENV CGO_ENABLED=0 GOOS=linux

# kubectl-convert
FROM golang AS kubectl-convert
WORKDIR /kubernetes
# renovate: datasource=github-tags depName=kubernetes/kubernetes
ENV KUBERNETES_VERSION=v1.31.0
RUN set -eux; \
    git clone --depth 1 https://github.com/kubernetes/kubernetes.git --branch "${KUBERNETES_VERSION:?}" .; \
    go install -ldflags '-s -w' ./cmd/kubectl-convert

FROM golang AS chart-prettier
# renovate: datasource=github-tags depName=utopia-planitia/chart-prettier
ENV CHART_PRETTIER_VERSION=v1.2.2
RUN set -eux; \
    go install -ldflags '-s -w' "github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION:?}"

# renovate
FROM docker.io/renovate/renovate:38.61.0-full@sha256:7fec14c7163596daa4a1141d00b392ae33880a0c89777269f928c63f48809cbe
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

# assert that the IDs of the base image's user did not change
RUN set -eux; \
    test "$(id -u)" -eq '1000'; \
    test "$(id -g)" -eq '0'

USER 0:0
# renovate: datasource=github-releases depName=helmfile/helmfile
ENV HELMFILE_VERSION=v0.167.1
# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize extractVersion=^kustomize/(?<version>v\d+(\.\d+)+)$
ENV KUSTOMIZE_VERSION=v5.4.3
# renovate: datasource=github-releases depName=mikefarah/yq
ENV YQ_VERSION=v4.44.3
RUN set -eux; \
    # vum ex curl jq
    apt-get update; \
    apt-get upgrade --assume-yes; \
    DEBIAN_FRONTEND=noninteractive apt-get install --assume-yes --no-install-recommends \
        curl \
        jq \
        vim \
        ; \
    apt-get clean; \
    rm -fr /var/lib/apt/lists/*; \
    # gofmt
    ln -s "$(find / -type f -executable -name gofmt -print -quit 2>/dev/null)" /usr/bin/gofmt; \
    command -v gofmt | tee /dev/stderr | grep -Fqx /usr/bin/gofmt; \
    gofmt -h; \
    # yq
    ARCH="$(go env GOARCH)"; \
    curl -fsSL -o /usr/bin/yq "https://github.com/mikefarah/yq/releases/download/${YQ_VERSION:?}/yq_linux_${ARCH:?}"; \
    chmod +x /usr/bin/yq; \
    # helmfile
    curl -fsSL -o helmfile.tar.gz "https://github.com/helmfile/helmfile/releases/download/${HELMFILE_VERSION:?}/helmfile_${HELMFILE_VERSION//v}_linux_${ARCH:?}.tar.gz"; \
    tar xzf helmfile.tar.gz -C /usr/bin helmfile; \
    rm helmfile.tar.gz; \
    # kustomize
    curl -fsSL -o kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2F${KUSTOMIZE_VERSION:?}/kustomize_${KUSTOMIZE_VERSION:?}_linux_${ARCH:?}.tar.gz"; \
    tar xzf kustomize.tar.gz -C /usr/bin; \
    rm -fr kustomize.tar.gz

# compiled tools
COPY --from=chart-prettier /go/bin/chart-prettier /usr/bin/
COPY --from=kubectl-convert /go/bin/kubectl-convert /usr/bin/

USER 1000:0

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
