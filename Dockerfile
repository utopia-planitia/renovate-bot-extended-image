FROM renovate/renovate:24.119.11@sha256:947ea9116eefe12e8839137a3cea4392de40f2fea643e8c53e19c1a35db50030

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
