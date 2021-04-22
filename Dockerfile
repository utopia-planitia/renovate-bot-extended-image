FROM renovate/renovate:24.119.10@sha256:8fb90fa4fa1314a7b725347461f73e2a400566c463ff77bbce6d05a26bb4f16d

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
