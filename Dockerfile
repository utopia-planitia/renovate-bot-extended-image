FROM renovate/renovate:25.18.0@sha256:2ecc796adf68698117de6010c4afa3fcaa738bc98239da320e87d2cb46e35c56

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
