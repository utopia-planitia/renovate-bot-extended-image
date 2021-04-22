FROM renovate/renovate:24.119.11@sha256:5c33281cc7f6aca721d434ee665d00409cacbf9450f5f0bb4645ac9b9ed4e669

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
