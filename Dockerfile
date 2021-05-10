FROM renovate/renovate:25.18.2@sha256:d45100c4f0b989f431ebd53ea463468dde6f0722ffe75bcde8233caf09342844

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
RUN renovate --version
