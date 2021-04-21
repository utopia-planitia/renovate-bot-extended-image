FROM renovate/renovate:24.119.5@sha256:f601b464deccca4c44005072d572477ccfdc544bcf48f8aa15213df9ad735a0d

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
