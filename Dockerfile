FROM renovate/renovate:25.18.5@sha256:5ebc2f6e69e7f106e0df758897cc92463ce465eaea0b15b607c9e8c2842e4e25

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
