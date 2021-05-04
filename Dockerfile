FROM renovate/renovate:24.119.16@sha256:59a0df154a882c006dd6fb506189b2be3ee08c50971283cd0d12ec233d95ed25

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
