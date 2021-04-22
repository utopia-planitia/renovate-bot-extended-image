FROM renovate/renovate:24.119.11@sha256:ad517462f966d72d1529f38f2132027728eacb51c023f0f58a7b98b23edfc94e

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
