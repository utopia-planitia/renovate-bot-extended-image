FROM renovate/renovate:24.119.17@sha256:67d71c5dd7f5c59abd111764a817d1d766655899fea70e024a05b827797e1932

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
