FROM renovate/renovate:25.16.2@sha256:ca79a6a41008d03229fd29b9009a6554fd162a0e8f5dd110560d5cae9b069e81

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
