FROM renovate/renovate:25.18.2@sha256:05c1f70fda7008faeb53718517be626668a1591fd445bbbc187525a504495899

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
