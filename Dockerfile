FROM renovate/renovate:25.18.4@sha256:0347fbca120827a5c142d813a80054dfe441d08f5266c8c1cbc05d8159e44351

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
