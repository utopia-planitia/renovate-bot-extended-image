FROM renovate/renovate:24.119.11@sha256:f841dbb4917909e5f9e1f6f42b71f0c8c0389a8bf4c329d4a0832c0c671107a7

USER root

RUN apt update

RUN apt install -y curl jq

RUN pip3 install yq

ENV MSORT_VERSION=v0.1.0
RUN go install github.com/utopia-planitia/msort@${MSORT_VERSION}

# checks
RUN curl --version
RUN jq --version
RUN yq --version
RUN go version

USER ubuntu
