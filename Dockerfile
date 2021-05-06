FROM renovate/renovate:24.119.22@sha256:2948ec244387f4220c1b66ae2e94699895ca27f4a6c3ebd8682937ae172a83f7

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
