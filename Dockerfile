FROM renovate/renovate:24.117.0@sha256:5626663b51a857df6d9d56b297776ce65760574635b71c52f4c1cc1644c1c518

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
