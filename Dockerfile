FROM docker.io/library/golang:1.24.4-alpine@sha256:68932fa6d4d4059845c8f40ad7e654e626f3ebd3706eef7846f319293ab5cb7a AS golang
SHELL [ "/bin/ash", "-o", "pipefail", "-c" ]
RUN set -eux; \
    apk upgrade --no-cache; \
    apk add --no-cache git
ENV CGO_ENABLED=0 GOOS=linux

# kubectl-convert
FROM golang AS kubectl-convert
WORKDIR /kubernetes
# renovate: datasource=github-tags depName=kubernetes/kubernetes
ENV KUBERNETES_VERSION=v1.33.2
RUN set -eux; \
    git clone --depth 1 https://github.com/kubernetes/kubernetes.git --branch "${KUBERNETES_VERSION:?}" .; \
    go install -ldflags '-s -w' ./cmd/kubectl-convert

FROM golang AS chart-prettier
# renovate: datasource=github-tags depName=utopia-planitia/chart-prettier
ENV CHART_PRETTIER_VERSION=v1.2.2
RUN set -eux; \
    go install -ldflags '-s -w' "github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION:?}"

# renovate
FROM docker.io/renovate/renovate:41.21.1-full@sha256:7d1f84a3dce50a523d93085171c4cfd7e5bf41572f73175e6467528729126b63
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]

# assert that the IDs of the base image's user did not change
ARG DEFAULT_USER=12021
ARG DEFAULT_GROUP=0
RUN set -eux; \
    test "$(id -u)" -eq "${DEFAULT_USER:?}"; \
    test "$(id -g)" -eq "${DEFAULT_GROUP:?}"

USER 0:0
# renovate: datasource=github-releases depName=helmfile/helmfile
ENV HELMFILE_VERSION=v1.1.2
# renovate: datasource=github-releases depName=kubernetes-sigs/kustomize extractVersion=^kustomize/(?<version>v\d+(\.\d+)+)$
ENV KUSTOMIZE_VERSION=v5.7.0
# renovate: datasource=github-releases depName=mikefarah/yq
ENV YQ_VERSION=v4.45.4
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

USER "${DEFAULT_USER:?}:${DEFAULT_GROUP:?}"

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
