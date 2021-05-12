FROM renovate/renovate:25.18.7@sha256:8ac1bb55cf787cbe265a5868fcbf5d3a6ba07fd3818da1abbc2ae88cdbe12dd0

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
