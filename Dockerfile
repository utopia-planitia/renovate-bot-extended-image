FROM renovate/renovate:25.21.4@sha256:0581dd4c18f9b99be1269e0d213e1c157cca86490a152089c33f72b7b050b96a

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
