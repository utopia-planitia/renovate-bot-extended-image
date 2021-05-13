FROM renovate/renovate:25.20.1@sha256:54a3a44196580c97315e66e55264a1b8d39f1ade1a3aee50f721e980b31073e0

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
