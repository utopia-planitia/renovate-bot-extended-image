FROM renovate/renovate:25.16.2@sha256:548eee40bf176c93b3446cce219c2f07ff73b0435796f503a1a8ee962f5d53e4

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
