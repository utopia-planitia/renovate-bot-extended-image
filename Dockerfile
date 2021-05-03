FROM renovate/renovate:24.119.15@sha256:a7a947a31a931c6924757b71ce033e23b92043149dda4d3c78322c658ed4b895

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
