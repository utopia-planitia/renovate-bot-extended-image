FROM renovate/renovate:25.18.7@sha256:3ffa8085ad0b2bcde0c31f688ead6e21f787e664275161237b64faae9ef17a9c

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
