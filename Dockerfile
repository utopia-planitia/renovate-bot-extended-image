# kubectl-convert
FROM golang:1.16.5-buster@sha256:55e10cd0c6fd093c02072b9237b1a2a7a3650155925cceec7805bc3ff31891f8 AS golang

RUN git clone --depth 1 https://github.com/kubernetes/kubernetes.git -b v1.21.0
RUN cd kubernetes && go install ./cmd/kubectl-convert

ENV CHART_PRETTIER_VERSION=v1.1.0
RUN go get github.com/utopia-planitia/chart-prettier@${CHART_PRETTIER_VERSION}

# renovate
FROM renovate/renovate:25.53.2@sha256:604e0435177af38d0aa37f883ce66af68d1d673e8502ccef52371b115a9e0cf2

USER root

RUN apt-get update \
 && apt-get install -y ca-certificates

RUN update-ca-certificates

# vum ex curl jq
RUN apt install -y vim curl jq

# yq
RUN pip3 install yq

# helmfile
ENV HELMFILE_VERSION=v0.139.9
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
