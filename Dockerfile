FROM renovate/renovate:25.19.2@sha256:01b84d8dfc9189421670a6ba57be717a8bf9ae8d9603efe87b6d2e7c0959f531

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
