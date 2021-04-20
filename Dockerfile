FROM renovate/renovate:24.117.0@sha256:e83678c37aa18737dd3b55d0ffbf02809894c8ac633d8a5c3d5e56a7c04522b7

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
