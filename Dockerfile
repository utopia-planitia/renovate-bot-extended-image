FROM renovate/renovate:24.119.2@sha256:92cdcccd00182ad27df5d0044f0704ac63c0637877ecaccb74037be63a8be0ca

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
