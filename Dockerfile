FROM renovate/renovate:24.119.10@sha256:f62cf8379f65a25c553437e495f3265d58b8c59400a8a0f84227befb90ce707c

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
