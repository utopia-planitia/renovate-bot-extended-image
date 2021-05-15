FROM renovate/renovate:25.21.8@sha256:a2e11e628834fa9746e658ca2f3d3094688cb1df8ad1dca249a8a4c629515396

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
