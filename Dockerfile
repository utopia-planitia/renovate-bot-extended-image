FROM renovate/renovate:25.19.1@sha256:2c18c0dbe5987d9e70b0cace580664ba4d358323609b1106082db699f81f280c

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
