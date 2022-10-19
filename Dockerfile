# kubectl-convert
FROM golang:1.17.7-buster@sha256:3d11eb4c0032307bbecbb40c30c0719006f4960f8ae4d01383e6b442425a9057 AS golang

ENV KUBERNETES_VERSION=v1.23.4
RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b ${KUBERNETES_VERSION}
RUN cd kubernetes && go install ./cmd/kubectl-convert

ENV CHART_PRETTIER_VERSION=v1.2.2
RUN go get github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION}

# renovate
FROM renovate/renovate:31.74.1@sha256:2de2be8eb9ace4274b12a0a9d82f1168f55b7713b19855f6f544ec6b795e1160

USER root

RUN apt-get update

# gofmt
RUN set -eux; \
    ln -s "$(find /usr/local -type f -executable -name gofmt -print -quit 2>/dev/null)" /usr/local/bin/gofmt; \
    /usr/local/bin/gofmt -h

# vum ex curl jq
RUN apt install -y vim curl jq

# yq
RUN pip3 install yq

# helmfile
ENV HELMFILE_VERSION=v0.143.0
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
