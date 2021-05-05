FROM renovate/renovate:24.119.17@sha256:53749e64fb1f545336277ca6191dd6915eb88263ad27624ee908959d8739102c

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
