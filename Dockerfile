FROM renovate/renovate:24.119.14@sha256:93b4753231138130822d75e2a562124aac22b0158bc070f156dc42346ea9b868

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
