FROM renovate/renovate:25.18.4@sha256:0932507ed3d72ea91c2fc91ab7a550af0ef39c213bf3b76aa21b16f64d44e430

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
