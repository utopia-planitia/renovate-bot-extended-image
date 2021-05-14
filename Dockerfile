FROM renovate/renovate:25.21.3@sha256:59372e2a7b776a9f713772c1c283eec3367a20bbbaf2b272533191d540e7e6d1

USER root

RUN apt update

RUN apt install -y curl jq

RUN pip3 install yq

USER ubuntu

ENV MSORT_VERSION=v0.1.0
RUN go install github.com/utopia-planitia/msort@${MSORT_VERSION}

# checks
RUN curl --version
RUN jq --version
RUN yq --version
RUN go version
RUN renovate --version
