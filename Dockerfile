FROM renovate/renovate:24.119.13@sha256:4abba4cbea6f09c6ca98c2817f8a7410395042f4983b9a35b020e7cdb4bcce7a

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
