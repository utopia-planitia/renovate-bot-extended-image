FROM renovate/renovate:25.21.10@sha256:59040140b40a60ba0598ce1891b11db76575e99aa1fd9f29bf7cdd7784013f34

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
