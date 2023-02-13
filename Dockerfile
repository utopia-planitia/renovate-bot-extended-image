# kubectl-convert
FROM golang:1.20.0-buster@sha256:f8fbd744a9129e3b705362d39c17f0cbdafd1979a08508ba2d72e488fdf98e22 AS golang
SHELL [ "/bin/bash", "-o", "pipefail", "-c" ]
ENV CGO_ENABLED=0

ENV KUBERNETES_VERSION=v1.26.1
RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b ${KUBERNETES_VERSION}
RUN cd kubernetes && go install ./cmd/kubectl-convert

ENV CHART_PRETTIER_VERSION=v1.2.2
RUN set -eux; \
    go install "github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION:?}"

# renovate
FROM renovate/renovate:34.132.2@sha256:da66e9df656a54c771b9a4c52049dde9029b4287fc184d83067b70890cea7355
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
