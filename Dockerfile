# kubectl-convert
FROM golang:1.17.6-buster@sha256:a5ba2c081bc7174317ce7f54cf5689c2365454b11a5e271a911d6a2edec1163d AS golang

ENV KUBERNETES_VERSION=v1.23.3
RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b ${KUBERNETES_VERSION}
RUN cd kubernetes && go install ./cmd/kubectl-convert

ENV CHART_PRETTIER_VERSION=v1.2.2
RUN go get github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION}

# renovate
FROM renovate/renovate:31.68.4@sha256:b4ece466d35629986a9a74a10d3b73b781e884bd71fe1f5d5630ec357e69a859

USER root

RUN apt-get update

# gofmt
RUN ln -s /usr/local/buildpack/go/1.17.6/bin/gofmt /usr/local/bin/gofmt

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
