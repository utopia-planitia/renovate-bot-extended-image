FROM renovate/renovate:24.119.13@sha256:d0287f2499a305030357126e4cf9e7e3cbc59913cb2a6df29ea1ccb83a2ec179

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
