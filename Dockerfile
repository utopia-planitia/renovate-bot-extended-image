FROM renovate/renovate:24.119.16@sha256:368fb608d94f32ad3a9b62d141b1f3e00a72b67bd43a7c92a1c83c4c8db224f9

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
