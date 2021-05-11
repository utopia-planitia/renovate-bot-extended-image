FROM renovate/renovate:25.18.6@sha256:571bddd2f42a73d999d60143c77313388f952c6f6d73bb12768d6cd734af35fd

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
